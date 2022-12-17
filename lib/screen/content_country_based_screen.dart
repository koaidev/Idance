import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/bloc/country_movie/country_movie_bloc.dart';
import 'package:oxoo/models/content_by_country_model.dart';
import 'package:oxoo/screen/tv_series/tv_series_details_screen.dart';

import '../../bloc/search/search_bloc.dart';
import '../../server/repository.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/loadingIndicator.dart';
import '../models/home_content.dart';
import 'movie/movie_details_screen.dart';

// ignore: must_be_immutable
class ContentCountryBasedScreen extends StatefulWidget {
  // static final String route = '/ContentCountryBasedScreen';
  final String? countryID;
  final String? countryName;
  bool isDark = Hive.box('appModeBox').get('isDark') ?? false;
  final List<AllGenre>? listGenres;

  ContentCountryBasedScreen(
      {Key? key, this.countryID, this.countryName, required this.listGenres})
      : super(key: key);

  @override
  State<ContentCountryBasedScreen> createState() {
    return _ContentCountryBasedScreenState();
  }
}

class _ContentCountryBasedScreenState extends State<ContentCountryBasedScreen> {
  List<Movie> movieList = [];
  List<Movie> mList = [];
  late ContentByCountryModel countryModel;
  double? cardWidth;

  // Future<List<Movie>> getAllMovieByCountryId() async{
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    cardWidth = MediaQuery.of(context).size.width / 3.1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.isDark
            ? CustomTheme.colorAccentDark
            : CustomTheme.primaryColor,
        title: Text(widget.countryName!),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Container(
        color: widget.isDark
            ? CustomTheme.primaryColorDark
            : CustomTheme.whiteColor,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CountryMovieBloc>(
              create: (context) => CountryMovieBloc(repository: Repository())
                ..add(GetMovieByCountryEvent(countryId: widget.countryID!)),
            ),
          ],
          child: BlocBuilder<CountryMovieBloc, CountryMovieState>(
            builder: (context, state) {
              if (state is SearchErrorState) {
                return Center(
                  child: Text(AppContent.somethingWentWrong,
                      style: widget.isDark
                          ? CustomTheme.bodyText2White
                          : CustomTheme.bodyText2),
                );
              }
              if (state is CountryMovieLoadedState) {
                movieList.addAll(state.countryModel.movieList);
                mList = movieList;
                countryModel = state.countryModel;
                return buildUI(context, mList);
              }
              return Center(
                child: spinkit,
              );
            },
          ),
        ),
      ),
    );
  }

  final List<LinearGradient> gradientBG = [
    CustomTheme.gradient1,
    CustomTheme.gradient2,
    CustomTheme.gradient3,
    CustomTheme.gradient4,
    CustomTheme.gradient5,
    CustomTheme.gradient6,
  ];

  int index = 0;

  LinearGradient getRandomColor() {
    if (index >= 5) {
      index = 0;
    }
    index++;
    return gradientBG[index];
  }

  Widget showListGenreFilter(BuildContext context, List<AllGenre> listGenres) {
    return Container(
        padding: EdgeInsets.only(left: 2),
        height: 115,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listGenres.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    getAllMovieByGen(listGenres.elementAt(index).name!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        gradient: getRandomColor(),
                      ),
                      margin: EdgeInsets.only(right: 2),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.network(
                                listGenres[index].imageUrl!,
                                width: 35,
                                height: 35,
                              ),
                            ),
                            Container(
                              child: Text(listGenres[index].name!,
                                  style: CustomTheme.bodyText3White),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  //thêm tính năng lọc phim theo id
  void getAllMovieByGen(String genreId) {
    this.mList.clear();
    List<Movie> mList = [];
    for (int i = 0; i < movieList.length; i++) {
      if (movieList[i].description != null) {
        if (movieList[i].description!.contains(genreId)) {
          mList.add(movieList[i]);
        }
      }
    }
    setState(() {
      this.mList = mList;
    });
  }

  Widget buildUI(BuildContext context, List<Movie> movieList) {
    if (movieList.length == 0)
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              child: Text("${AppContent.showResultFor}${widget.countryName}",
                  style: CustomTheme.bodyText1),
            ),
          ),
          Text(AppContent.noitemshere, style: CustomTheme.bodyTextgray2),
          Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/bg_no_item_city.png')),
        ],
      );

    return CustomScrollView(
      slivers: <Widget>[
        if (movieList.length > 0)
          SliverToBoxAdapter(
            child: Container(
                margin: EdgeInsets.only(top: 2, bottom: 15),
                child: Column(
                  children: [
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.6, crossAxisCount: 3),
                      itemCount: movieList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // width: cardWidth,
                          height: 115,
                          margin: EdgeInsets.only(right: 2),
                          child: InkWell(
                            onTap: () {
                              if (movieList[index].isTvseries == "1") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TvSerisDetailsScreen(
                                      seriesID: movieList[index].videosId,
                                      isPaid: '',
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(
                                    context, MovieDetailScreen.route,
                                    arguments: {
                                      "movieID": movieList[index].videosId
                                    });
                              }
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Card(
                                  color: widget.isDark
                                      ? CustomTheme.darkGrey
                                      : Colors.white,
                                  elevation: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5.0),
                                            topRight: Radius.circular(5.0)),
                                        // child: Image.network(
                                        //   latestMovies![index].thumbnailUrl!,
                                        //   fit: BoxFit.fitWidth,
                                        //   height: 155,
                                        // ),
                                        child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/images/placeholder.png",
                                            placeholderScale: 25,
                                            height: 155,
                                            fit: BoxFit.fitWidth,
                                            imageErrorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                                      "assets/images/placeholder.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                            image:
                                                movieList[index].thumbnailUrl!),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 2),
                                        padding: EdgeInsets.only(
                                            right: 2, top: 2, bottom: 2),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              movieList[index].title!,
                                              overflow: TextOverflow.ellipsis,
                                              style: widget.isDark
                                                  ? CustomTheme.smallTextWhite
                                                      .copyWith(fontSize: 13)
                                                  : CustomTheme.smallText
                                                      .copyWith(fontSize: 13),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    movieList[index]
                                                        .videoQuality!,
                                                    textAlign: TextAlign.start,
                                                    style: widget.isDark
                                                        ? CustomTheme
                                                            .smallTextWhite
                                                        : CustomTheme
                                                            .smallText),
                                                Expanded(
                                                  child: Text(
                                                      movieList[index].release!,
                                                      textAlign: TextAlign.end,
                                                      style: widget.isDark
                                                          ? CustomTheme
                                                              .smallTextWhite
                                                          : CustomTheme
                                                              .smallText),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                  ],
                )),
          ),
      ],
    );
  }
}
