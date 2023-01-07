import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kochava_tracker/kochava_tracker.dart';
import 'package:oxoo/models/user.dart';
import 'package:oxoo/network/api_firebase.dart';
import 'package:oxoo/widgets/movie_details_video_player.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../bloc/tv_seris/tv_seris_bloc.dart';
import '../../constants.dart';
import '../../models/configuration.dart';
import '../../models/payment_object.dart';
import '../../models/tv_series_details_model.dart';
import '../../models/video_comments/ad_comments_model.dart';
import '../../models/video_comments/all_comments_model.dart';
import '../../models/video_paid.dart';
import '../../screen/auth/auth_screen.dart';
import '../../screen/subscription/premium_subscription_screen.dart';
import '../../server/repository.dart';
import '../../service/get_config_service.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/button_widget.dart';
import '../../utils/loadingIndicator.dart';
import '../../utils/price_converter.dart';
import '../../utils/validators.dart';
import '../../viewmodel/movie_view_model.dart';
import '../../widgets/movie/movie_details_youtube_player.dart';
import '../../widgets/movie_play_for_ios.dart';
import '../../widgets/share_btn.dart';
import '../../widgets/tv_series/cast_crew_item_card.dart';
import '../../widgets/tv_series/episode_item_card.dart';
import '../../widgets/tv_series/related_tvseries_card.dart';
import '../movie/movie_reply_screen.dart';
import 'package:http/http.dart' as http;

import '../payment/select_method_payment_dialog.dart';


class TvSerisDetailsScreen extends StatefulWidget {
  final String? seriesID;
  final String? isPaid;

  TvSerisDetailsScreen({Key? key, required this.seriesID, required this.isPaid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TvSerisDetailsScreenState();
}

class _TvSerisDetailsScreenState extends State<TvSerisDetailsScreen> {
  TvSeriesDetailsModel? tvSeriesDetailsModel;
  TextEditingController editingController = new TextEditingController();
  Season? selectedSeason;
  String selectedSeasonName = "";
  bool isSeriesPlaying = false;
  static bool? isDark;
  var appModeBox = Hive.box('appModeBox');
  bool isLoadingBraintree = false;
  bool isUserValidSubscriber = false;
  UserIDance? userIDance;
  List<VideoPaid> listVideosPaid = [];


  checkVideoPaid() async {
    final response = await http.get(Uri.parse(
        "http://apppanel.cnagroup.vn/rest_api/v1/id/${ApiFirebase().uid}"));
    if (response.statusCode == 200) {
      print("VideoPaids: ${response.body}");
      var paymentObject = PaymentObject.fromJson(jsonDecode(response.body));
      if (paymentObject.data?.isNotEmpty == true) {
        VideosPaid videosPaid = await ApiFirebase()
            .getVideosPaid()
            .get()
            .then((value) => value.data() as VideosPaid);
        print("VideosPaid: ${videosPaid.listVideoPaid.toString()}");
        paymentObject.data!.forEach((element) async {
          if (element.orderInfo?.contains("video") == true &&
              element.orderInfo?.replaceAll(RegExp('[^0-9]'), '') ==
                  tvSeriesDetailsModel?.videosId) {
            if (!videosPaid.listVideoPaid!.any((video) =>
            video.videoId.toString() ==
                element.orderInfo?.replaceAll(RegExp('[^0-9]'), ''))) {
              bool response2 = await ApiFirebase().updateNewVideosPaid(
                  new VideoPaid(
                      videoId: int.parse(tvSeriesDetailsModel?.videosId ?? "0"),
                      numberCanWatch: tvSeriesDetailsModel?.numberCanWatch ?? 0,
                      uid: ApiFirebase().uid,
                      status: true),
                  true);
              print("StatusVideo: $response2");
            } else if (videosPaid.listVideoPaid!.any((video) =>
            video.videoId.toString() ==
                element.orderInfo?.replaceAll(RegExp('[^0-9]'), '') &&
                video.status == false)) {
              bool response2 = await ApiFirebase().updateNewVideosPaid(
                  new VideoPaid(
                      videoId: int.parse(tvSeriesDetailsModel?.videosId ?? "0"),
                      numberCanWatch: tvSeriesDetailsModel?.numberCanWatch,
                      uid: ApiFirebase().uid,
                      status: true),
                  true);
              print("ONADD: $response2");
              bool response3 = await ApiFirebase().updateNewVideosPaid(
                  new VideoPaid(
                      videoId: int.parse(tvSeriesDetailsModel?.videosId ?? "0"),
                      numberCanWatch: 0,
                      uid: ApiFirebase().uid,
                      status: false),
                  false);
              print("ONREMOVE: $response3");
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("_TvSerisDetailsScreenState");

    isDark = appModeBox.get('isDark') ?? false;
    final configService = Provider.of<GetConfigService>(context);
    PaymentConfig? paymentConfig = configService.paymentConfig();

    return StreamBuilder<DocumentSnapshot>(
        stream: ApiFirebase().getUserStream(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            userIDance = UserIDance(uid: ApiFirebase().uid);
          }
          if (snapshot.hasData) {
            userIDance = (snapshot.data?.data() ??
                UserIDance(uid: ApiFirebase().uid)) as UserIDance?;
          }
          isUserValidSubscriber = userIDance?.currentPlan != "free";
          return StreamBuilder<DocumentSnapshot>(
              stream: ApiFirebase().getVideosPaidStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot2) {
                if (snapshot.hasError) {
                  listVideosPaid = [];
                }
                if (snapshot.hasData) {
                  listVideosPaid =
                      (snapshot2.data?.data() as VideosPaid?)?.listVideoPaid ??
                          [];
                }
                print(
                    "VideosPaid: ${(snapshot2.data?.data() as VideosPaid?)
                        ?.listVideoPaid}");
                return Scaffold(
                  backgroundColor: isDark!
                      ? CustomTheme.colorAccentDark
                      : CustomTheme.primaryColor,
                  body: BlocProvider<TvSerisBloc>(
                    create: (BuildContext context) =>
                    TvSerisBloc(Repository())
                      ..add(GetTvSerisEvent(
                          seriesId: widget.seriesID,
                          userId: ApiFirebase().uid)),
                    child: BlocBuilder<TvSerisBloc, TvSerisState>(
                      builder: (context, state) {
                        if (state is TvSerisIsLoaded) {
                          if (widget.isPaid == "1" &&
                              !ApiFirebase().isLogin()) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AuthScreen(
                                        fromPaidScreen: true,
                                      ),
                                ),
                              );
                            });
                          } else {
                            // tvSeriesDetailsModel = state.tvSeriesDetailsModel;
                            // if (!isUserValidSubscriber &&
                            //     tvSeriesDetailsModel!.isPaid == "1") {
                            //   return Scaffold(
                            //     backgroundColor:
                            //         isDark! ? CustomTheme.black_window : Colors.white,
                            //     body: subscriptionInfoDialog(
                            //         context: context,
                            //         isDark: isDark!,
                            //         userId: ApiFirebase().uid),
                            //   );
                            // } else {
                            if (state.tvSeriesDetailsModel != null) {
                              tvSeriesDetailsModel = state.tvSeriesDetailsModel;

                              if (tvSeriesDetailsModel != null) {
                                if (tvSeriesDetailsModel!.season!.length > 0) {
                                  selectedSeason =
                                      tvSeriesDetailsModel!.season!.elementAt(
                                          0);
                                }
                                return Stack(
                                  children: [
                                    buildUI(context,
                                        tvSeriesDetailsModel!.videosId),
                                    if (isLoadingBraintree) spinkit,
                                  ],
                                );
                              }
                              return Center(
                                child: Text(AppContent.loadingData),
                              );
                            }
                            // }
                            return Center(
                              child: spinkit,
                            );
                          }
                        }
                        return Center(child: spinkit);
                      },
                    ),
                  ),
                );
              });
        });
  }

  ///build subscriptionInfo Dialog
  Widget subscriptionInfoDialog(
      {required BuildContext context, required bool isDark, String? userId}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? CustomTheme.darkGrey : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Bạn cần đăng ký gói trả phí để học bài nhảy này.",
                  style: CustomTheme.authTitle,
                  textAlign: TextAlign.center,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: CustomTheme.primaryColor,
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PremiumSubscriptionScreen(
                                      fromRadioScreen: false,
                                      fromLiveTvScreen: true,
                                      liveTvID: "1",
                                      isPaid: widget.isPaid)),
                        );
                      },
                      child: Text(
                        "Đăng ký gói học ngay",
                        style: CustomTheme.bodyText3White,
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: CustomTheme.primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppContent.goBack,
                          style: CustomTheme.bodyText3White),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUI(BuildContext context, String? videoId) {
    checkVideoPaid();
    return FutureBuilder(
      future: Repository().getAllComments(videoId),
      builder:
          (context, AsyncSnapshot<AllCommentModelList?> allCommentModelList) {
        // ignore: unnecessary_null_comparison
        if (allCommentModelList.connectionState == ConnectionState.none &&
            allCommentModelList.hasData == null) {
          return Container();
        }
        return ScopedModel<MovieViewModel>(
          model: MovieViewModel(),
          child: ScopedModelDescendant<MovieViewModel>(
              builder: (context, child, model) =>
                  Scaffold(
                    body: Container(
                      color: isDark!
                          ? CustomTheme.primaryColorDark
                          : CustomTheme.whiteColor,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isSeriesPlaying)
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            height: 330.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    tvSeriesDetailsModel!
                                                        .posterUrl!),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 330.0,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black87,
                                                  Colors.black87,
                                                  isDark!
                                                      ? Colors.black
                                                      : Colors.white,
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 10.0),
                                            width: 140,
                                            height: 200.0,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6.0)),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        tvSeriesDetailsModel!
                                                            .thumbnailUrl!),
                                                    fit: BoxFit.fill)),
                                          ),
                                          Container(
                                            height: 280.0,
                                            alignment: Alignment.bottomLeft,
                                            margin:
                                            new EdgeInsets.only(left: 10),
                                            width: 200.0,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tvSeriesDetailsModel!.title!,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                HelpMe().space(8.0),
                                                if ((tvSeriesDetailsModel
                                                    ?.isPaid == "1" &&
                                                    !(isUserValidSubscriber ||
                                                        listVideosPaid.any((
                                                            element) =>
                                                        element.videoId
                                                            .toString() ==
                                                            tvSeriesDetailsModel
                                                                ?.videosId &&
                                                            element
                                                                .numberCanWatch !=
                                                                0))))
                                                  Container(
                                                    // width:
                                                    // MediaQuery
                                                    //     .of(context)
                                                    //     .size
                                                    //     .width - 170,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: CustomTheme
                                                            .primaryColorRed,
                                                      ),
                                                      onPressed: () {
                                                        SelectMethodPaymentDialog()
                                                            .createDialog(
                                                            context,
                                                            "${tvSeriesDetailsModel
                                                                ?.title} - video${
                                                            tvSeriesDetailsModel
                                                            ?.videosId
                                                        }",
                                                            int.parse(
                                                                tvSeriesDetailsModel
                                                                    !.videosId!),
                                                            (tvSeriesDetailsModel
                                                                ?.numberCanWatch ??
                                                                -1),
                                                            (tvSeriesDetailsModel!
                                                                .price! > 0
                                                                ? tvSeriesDetailsModel!
                                                                .price!
                                                                : 10000),
                                                            isDark);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 4.0,
                                                            horizontal: 4.0),
                                                        child: Text(
                                                          "Mua ngay chỉ với ${PriceConverter
                                                              .convertPrice(
                                                              tvSeriesDetailsModel!
                                                                  .price! > 0
                                                                  ? tvSeriesDetailsModel!
                                                                  .price!
                                                                  : 10000)}đ\n${tvSeriesDetailsModel!
                                                              .numberCanWatch ==
                                                              -1
                                                              ? 'Vĩnh viễn'
                                                              : '${tvSeriesDetailsModel!
                                                              .numberCanWatch} lượt xem'}",
                                                          style: CustomTheme
                                                              .bodyText3White,
                                                          textAlign: TextAlign
                                                              .center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                HelpMe().space(8.0),
                                                if (tvSeriesDetailsModel!
                                                    .trailerUrl?.isNotEmpty ==
                                                    true)
                                                  Container(
                                                    width:
                                                    MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width - 170,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        KochavaTracker.instance.sendEvent("Số lượt xem thử ${tvSeriesDetailsModel?.title??'KHÔNG XÁC ĐỊNH'}");
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    MovieDetailsYoutubePlayer(
                                                                        url: tvSeriesDetailsModel
                                                                            ?.trailerUrl)));
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: CustomTheme
                                                            .whiteColor,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 14.0,
                                                            horizontal: 10.0),
                                                        child: Text("Xem thử",
                                                            style: CustomTheme
                                                                .bodyText3),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50.0, horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                            )),
                                        ShareApp(
                                          title: tvSeriesDetailsModel!.title,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            HelpMe().space(20.0),
                            if (selectedSeason != null)
                              Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 45.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: new DropdownButton<Season>(
                                      value: selectedSeason,
                                      hint: Text(
                                        selectedSeasonName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      isExpanded: true,
                                      underline: Container(
                                        width: 0.0,
                                        height: 0.0,
                                      ),
                                      onChanged: (newValue) {
                                        selectedSeason = newValue;
                                        selectedSeasonName =
                                        newValue!.seasonsName!;

                                        model.setCurrentSeason(newValue);
                                        model.setCurrentSeasonName(
                                            newValue.seasonsName);
                                      },
                                      items: tvSeriesDetailsModel!.season!
                                          .map((season) {
                                        return new DropdownMenuItem<Season>(
                                          value: season,
                                          child: new Text(
                                            "Chế độ: " + season.seasonsName!,
                                            style: new TextStyle(
                                                color: Colors.grey),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            if (selectedSeason != null)
                              Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                height: 170.0,
                                child: ListView.builder(
                                    itemCount: selectedSeason!.episodes!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      model.setCurrentSeason(selectedSeason);
                                      return InkWell(
                                        onTap: () {
                                          print("tapped_on_episodeItem_card");
                                          // isSeriesPlaying = true;
                                          // setState(() {});
                                          if (isUserValidSubscriber ||
                                              listVideosPaid.any((element) =>
                                              (element.videoId.toString() ==
                                                  tvSeriesDetailsModel!.videosId &&
                                                  element.numberCanWatch != 0)) ||
                                              tvSeriesDetailsModel!.isPaid == "0"){
                                            KochavaTracker.instance.sendEvent("Số lượt xem ${tvSeriesDetailsModel?.title??'KHÔNG XÁC ĐỊNH'}");
                                            if (Platform.isIOS)
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LandscapePlayer(
                                                        videoUrl: model
                                                            .currentSeason
                                                            ?.episodes![index]
                                                            .fileUrl,
                                                      ),
                                                ),
                                              );
                                            if (Platform.isAndroid)
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieDetailsVideoPlayerWidget(
                                                        videoUrl: model
                                                            .currentSeason
                                                            ?.episodes![index]
                                                            .fileUrl,
                                                      ),
                                                ),
                                              );
                                          }else{
                                            showShortToast("Bạn cần đăng ký hoặc mua để xem video này.", context);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: EpisodeItemCard(
                                            episodeName: model
                                                .currentSeason?.episodes!
                                                .elementAt(index)
                                                .episodesName,
                                            imagePath: model
                                                .currentSeason?.episodes!
                                                .elementAt(index)
                                                .imageUrl,
                                            isDark: isDark,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(tvSeriesDetailsModel!.description!,
                                  style: isDark!
                                      ? CustomTheme.bodyText2White
                                      : CustomTheme.bodyText2),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppContent.director,
                                style: isDark!
                                    ? CustomTheme.bodyText1BoldWhite
                                    : CustomTheme.bodyText1Bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppContent.releaseOn} ${tvSeriesDetailsModel
                                    ?.release}",
                                style: isDark!
                                    ? CustomTheme.bodyText1BoldWhite
                                    : CustomTheme.bodyText1Bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppContent.genre,
                                style: isDark!
                                    ? CustomTheme.bodyText1BoldWhite
                                    : CustomTheme.bodyText1Bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppContent.castCrew,
                                style: isDark!
                                    ? CustomTheme.bodyText1BoldWhite
                                    : CustomTheme.bodyText1Bold,
                              ),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              height: 120.0,
                              child: ListView.builder(
                                  itemCount:
                                  tvSeriesDetailsModel!.castAndCrew!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CastCrewCard(
                                      castAndCrew: tvSeriesDetailsModel!
                                          .castAndCrew!
                                          .elementAt(index),
                                      isDark: isDark,
                                    );
                                  }),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppContent.youMayAlsoLike,
                                style: isDark!
                                    ? CustomTheme.bodyText1BoldWhite
                                    : CustomTheme.bodyText1Bold,
                              ),
                            ),
                            if (tvSeriesDetailsModel!.relatedTvseries != null)
                              Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                height: 200.0,
                                child: ListView.builder(
                                    itemCount: tvSeriesDetailsModel!
                                        .relatedTvseries!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RelatedTvSerisCard(
                                          relatedTvseries: tvSeriesDetailsModel!
                                              .relatedTvseries!
                                              .elementAt(index),
                                          isDark: isDark,
                                        ),
                                      );
                                    }),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppContent.comments,
                                style: isDark!
                                    ? CustomTheme.bodyText1BoldWhite
                                    : CustomTheme.bodyText1Bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                style: isDark!
                                    ? CustomTheme.bodyText2White
                                    : CustomTheme.bodyText2,
                                controller: editingController,
                                decoration: InputDecoration(
                                  hintText: AppContent.yourComments,
                                  filled: true,
                                  hintStyle: CustomTheme.bodyTextgray2,
                                  fillColor: isDark!
                                      ? Colors.black54
                                      : Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 0.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 0.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: isDark!
                                        ? CustomTheme.grey_transparent2
                                        : Colors.grey.shade300,
                                  ),
                                  onPressed: () {
                                    postComment(tvSeriesDetailsModel!);
                                  },
                                  child: Text(
                                    AppContent.addComments,
                                    style: TextStyle(
                                        color: CustomTheme.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            if (allCommentModelList.data != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: allCommentModelList
                                        .data?.commentsList?.length ??
                                        0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return commentItem(allCommentModelList
                                          .data!.commentsList![index]);
                                    }),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )),
        );
      },
    );
  }

  void postComment(TvSeriesDetailsModel data) async {
    String comment = editingController.text.toString();
    if (comment.isNotEmpty) {
      AddCommentsModel? model = await Repository().addComments(
          data.videosId,
          ApiFirebase().uid,
          comment,
          FirebaseAuth.instance.currentUser?.displayName ?? "IDANCE User");

      if (model != null) {
        editingController.clear();
        showShortToast(model.message ?? "", context);
        setState(() {});
      }
    }
  }

  Widget commentItem(AllCommentModel allCommentModelList) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Card(
        color: isDark! ? CustomTheme.colorAccentDark : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                child: Image.network(
                  allCommentModelList.userImgUrl != null
                      ? allCommentModelList.userImgUrl!
                      : "https://play-lh.googleusercontent.com/gbzvBNR9VaSxWKp2oMx2Dvl93cqb04EtQTxJPc1WKky_WMM2vYGI4faZ5MxVoFsk0SFp=w240-h480-rw",
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              SizedBox(width: 10.0),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allCommentModelList.userName ?? "IDANCE User",
                      style: isDark!
                          ? CustomTheme.bodyText2White
                          : CustomTheme.bodyTextgray2,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      allCommentModelList.comments!,
                      style: CustomTheme.smallTextGrey,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, MovieReplyScreen.route,
                              arguments: {
                                'commentsID': allCommentModelList.commentsId,
                                'videosID': allCommentModelList.videosId,
                                'userId': ApiFirebase().uid,
                                'isDark': true,
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppContent.reply,
                              style: CustomTheme.coloredBodyText3),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
