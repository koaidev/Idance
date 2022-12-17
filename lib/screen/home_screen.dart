import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/server/repository.dart';
import 'package:oxoo/utils/fab/action_button.dart';
import 'package:oxoo/utils/fab/expand_fab.dart';
import 'package:oxoo/widgets/home_screen/country_item.dart';
import 'package:oxoo/widgets/home_screen/popular_star_item.dart';
import 'package:oxoo/widgets/home_screen/tv_series_item.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/configuration.dart';
import '../../models/home_content.dart';
import '../../widgets/banner_ads.dart';
import '../service/get_config_service.dart';
import '../strings.dart';
import '../style/theme.dart';
import '../utils/loadingIndicator.dart';
import '../widgets/home_screen/features_genre_movies_item.dart';
import '../widgets/home_screen/genre_item.dart';
import '../widgets/home_screen/movie_item.dart';
import '../widgets/home_screen/slider.dart';

class HomeScreen extends StatefulWidget {
  static final String route = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var appModeBox = Hive.box('appModeBox');
  bool? isDark;
  late Future<HomeContent> _homeContent;

  @override
  void initState() {
    super.initState();
    isDark = appModeBox.get('isDark') ?? false;
    _homeContent = Repository().getHomeContent();
  }

  @override
  Widget build(BuildContext context) {
    final configService = Provider.of<GetConfigService>(context);

    // PaymentConfig? paymentConfig = configService.paymentConfig();
    AppConfig? appConfig = configService.appConfig();

    return Scaffold(
      backgroundColor:
          isDark! ? CustomTheme.primaryColorDark : Colors.transparent,
      body: FutureBuilder<HomeContent>(
        future: _homeContent,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Stack(children: [
              buildUI(
                  context: context,
                  // paymentConfig: paymentConfig,
                  appConfig: appConfig,
                  homeContent: snapshot.data),
              Align(alignment: Alignment.bottomRight, child: Container(padding: EdgeInsets.only(bottom: 16),child:ExpandableFab(
                iconData: Icons.support_agent_rounded,
                name: "Hỗ trợ",
                distance: 112.0,
                children: [
                  ActionButton(
                    onPressed: () => _launchURL('https://m.me/idance.vn'),
                    icon: Image.asset(
                      "assets/images/messenger.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  ActionButton(
                    onPressed: () => _launchURL("https://zalo.me/0888430620"),
                    icon: Image.asset(
                      "assets/images/zalo_icon.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
                alignment: Alignment.bottomRight,
              ),)),

              Align(alignment: Alignment.bottomLeft, child: Container(padding: EdgeInsets.only(bottom: 16),child: ExpandableFab(
                iconData: Icons.groups_outlined,
                name: "Cộng đồng",
                alignment: Alignment.bottomLeft,
                distance: 112.0,
                children: [
                  ActionButton(
                    onPressed: () => _launchURL('https://www.facebook.com/groups/idance.vn'),
                    icon: Image.asset(
                      "assets/images/fb.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  ActionButton(
                    onPressed: () => _launchURL("https://zalo.me/g/gxdkue195"),
                    icon: Image.asset(
                      "assets/images/zalo_icon.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),)),

            ],);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                AppContent.somethingWentWrong,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Center(
            child: spinkit,
          );
        },
      ),
    );
  }

  Widget buildUI(
      {BuildContext? context,
      // PaymentConfig? paymentConfig,
      AppConfig? appConfig,
      required HomeContent homeContent}) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5),
            child: ImageSlider(homeContent.slider),
          ),
        ),
        SliverToBoxAdapter(
          child: BannerAds(
            isDark: isDark,
          ),
        ),

        //cấp độ
        if (appConfig!.countryVisible)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: HomeScreenCountryList(
                countryList: homeContent.allCountry,
                isDark: isDark!,
                listGenres: homeContent.allGenre,
              ),
            ),
          ),

        //thể loại
        if (appConfig.genreVisible)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: HomeScreenGenreList(
                genreList: homeContent.allGenre,
                isDark: isDark,
              ),
            ),
          ),
        //Danh sách Giáo viên
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: HomeScreenPopularStarList(
              popularStarList: homeContent.popularStars!,
            ),
          ),
        ),
        //Latest movies
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 2, bottom: 15),
            child: HomeScreenMovieList(
              latestMovies: homeContent.latestMovies,
              context: context,
              title: AppContent.latestMovies,
              isDark: isDark,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 2, bottom: 15),
            child: HomeScreenSeriesList(
              latestTvSeries: homeContent.latestTvseries,
              title: AppContent.latestTvSeries,
              isDark: isDark,
            ),
          ),
        ),
        HomeScreenGenreMoviesList(
          genreMoviesList: homeContent.featuresGenreAndMovie,
          isDark: isDark,
        ),
      ],
    );
  }
}

void _launchURL(String _url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
