import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/server/repository.dart';
import 'package:oxoo/utils/fab/action_button.dart';
import 'package:oxoo/utils/fab/expand_fab.dart';
import 'package:oxoo/widgets/home_screen/country_item.dart';
import 'package:oxoo/widgets/home_screen/popular_star_item.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/configuration.dart';
import '../../models/home_content.dart';
import '../../widgets/banner_ads.dart';
import '../models/user_model.dart';
import '../service/authentication_service.dart';
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
    final authService = Provider.of<AuthService>(context);
    final configService = Provider.of<GetConfigService>(context);

    AuthUser? authUser = authService.getUser();
    PaymentConfig? paymentConfig = configService.paymentConfig();
    AppConfig? appConfig = configService.appConfig();

    return Scaffold(
      // floatingActionButton: FabCircularMenu(
      //   children: [
      //     Spacer(flex: 2),
      //     GestureDetector(
      //         onTap: () {
      //           _launchURL('https://m.me/idanceeee');
      //         },
      //         child: Container(
      //           height: 60,
      //           width: 60,
      //           padding: EdgeInsets.all(5),
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.all(Radius.circular(15)),
      //               color: Colors.white),
      //           child: Image.asset(
      //             "assets/images/messenger.png",
      //             fit: BoxFit.fill,
      //           ),
      //         )),
      //     Spacer(flex: 1),
      //     GestureDetector(
      //         onTap: () {
      //           _launchURL("https://zalo.me/g/gxdkue195");
      //         },
      //         child: Container(
      //           height: 60,
      //           width: 60,
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.all(Radius.circular(15)),
      //               color: Colors.white),
      //           child: Image.asset(
      //             "assets/images/zalo_icon.png",
      //             fit: BoxFit.fill,
      //           ),
      //         )),
      //   ],
      //   fabSize: 60,
      //   fabOpenIcon: Icon(Icons.support_agent_rounded),
      //   fabOpenColor: Colors.red,
      //   ringColor: Colors.transparent,
      //   fabColor: CustomTheme.gradient2.colors[1],
      // ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _launchURL('https://m.me/idanceeee'),
            icon: Image.asset(
              "assets/images/messenger.png",
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
      ),
      backgroundColor:
          isDark! ? CustomTheme.primaryColorDark : Colors.transparent,
      body: FutureBuilder<HomeContent>(
        future: _homeContent,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buildUI(
                context: context,
                authUser: authUser,
                paymentConfig: paymentConfig,
                appConfig: appConfig,
                homeContent: snapshot.data);
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
      PaymentConfig? paymentConfig,
      AuthUser? authUser,
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
        // SliverToBoxAdapter(
        //   child: Container(
        //     margin: EdgeInsets.only(top: 2, bottom: 15),
        //     child: HomeScreenSeriesList(
        //       latestTvSeries: homeContent.latestTvseries,
        //       title: AppContent.latestTvSeries,
        //       isDark: isDark,
        //     ),
        //   ),
        // ),
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
