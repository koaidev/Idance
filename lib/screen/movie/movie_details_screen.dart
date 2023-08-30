import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:kochava_tracker/kochava_tracker.dart';
import 'package:oxoo/bloc/movie_details/movie_details_bloc.dart';
import 'package:oxoo/network/api_firebase.dart';
import 'package:oxoo/utils/price_converter.dart';
import 'package:oxoo/widgets/movie/movie_poster.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../constants.dart';
import '../../models/configuration.dart';
import '../../models/favourite_response_model.dart';
import '../../models/movie_details_model.dart';
import '../../models/payment_object.dart';
import '../../models/user.dart';
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
import '../../utils/validators.dart';
import '../../widgets/movie/movie_details_youtube_player.dart';
import '../../widgets/movie/select_server_dialog.dart';
import '../../widgets/movie_details_video_player.dart';
import '../../widgets/share_btn.dart';
import '../../widgets/tv_series/cast_crew_item_card.dart';
import '../payment/select_method_payment_dialog.dart';
import 'movie_reply_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  static final String route = "/MovieDetailScreen";
  final String? movieID;

  const MovieDetailScreen({Key? key, this.movieID}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late MovieDetailsModel movieDetailsModel;
  TextEditingController commentsController = new TextEditingController();
  static bool? isDark;
  bool isDownloadEnable = false;
  var appModeBox = Hive.box('appModeBox');
  late bool _permissionReady;
  TargetPlatform? platform;
  String? _localPath;
  UserIDance? userIDance;
  bool isIos = false;

  bool isUserValidSubscriber = false;
  List<VideoPaid> listVideosPaid = [];

  @override
  void initState() {
    super.initState();
    isIos = Platform.isIOS;
    isDark = appModeBox.get('isDark') ?? false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _permissionReady = false;
    _prepare();
    // FlutterDownloader.registerCallback(downloadCallback);
  }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port')!;
  //   send.send([id, status, progress]);
  // }

  _prepare() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    print(_localPath);
    final savedDir = Directory(_localPath!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    setState(() {});
  }

  Future<String> _findLocalPath() async {
    _permissionReady = await _checkPermission();
    late var directory;
    if (_permissionReady) {
      directory = platform == TargetPlatform.android
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
    }
    return directory.path;
  }

  // Future<dynamic> downloadVideo(String videoUrl, String fileName) async {
  //   if (_permissionReady) {
  //     await FlutterDownloader.enqueue(
  //         url: videoUrl,
  //         savedDir: _localPath!,
  //         fileName: fileName,
  //         showNotification: true,
  //         openFileFromNotification: true);
  //   }
  // }

  ///Getting  Audio File Directory
  Future<List> getTotalDownloadedFile() async {
    return Directory('$_localPath').listSync();
  }

  ///Check Audio File Exists or Not and Return Bool
  Future<bool> checkVideoPath(String videoName) async {
    final file = await _localFile(videoName: videoName);
    // print(file.toString());
    bool contents = file.existsSync();
    return contents;
  }

  Future<File> _localFile({String? videoName}) async {
    return File('$_localPath$videoName');
  }

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
                  movieDetailsModel.videosId) {
            if (!videosPaid.listVideoPaid!.any((video) =>
                video.videoId.toString() ==
                element.orderInfo?.replaceAll(RegExp('[^0-9]'), ''))) {
              bool response2 = await ApiFirebase().updateNewVideosPaid(
                  new VideoPaid(
                      videoId: int.parse(movieDetailsModel.videosId),
                      numberCanWatch: movieDetailsModel.numberCanWatch,
                      uid: ApiFirebase().uid,
                      name: movieDetailsModel.title,
                      thumb: movieDetailsModel.thumbnailUrl,
                      status: true),
                  true);
              print("StatusVideo: $response2");
            } else if (videosPaid.listVideoPaid!.any((video) =>
                video.videoId.toString() ==
                    element.orderInfo?.replaceAll(RegExp('[^0-9]'), '') &&
                video.status == false)) {
              bool response2 = await ApiFirebase().updateNewVideosPaid(
                  new VideoPaid(
                      videoId: int.parse(movieDetailsModel.videosId),
                      numberCanWatch: movieDetailsModel.numberCanWatch,
                      name: movieDetailsModel.title,
                      thumb: movieDetailsModel.thumbnailUrl,
                      uid: ApiFirebase().uid,
                      status: true),
                  true);
              print("ONADD: $response2");
              bool response3 = await ApiFirebase().updateNewVideosPaid(
                  new VideoPaid(
                      videoId: int.parse(movieDetailsModel.videosId),
                      numberCanWatch: 0,
                      name: movieDetailsModel.title,
                      thumb: movieDetailsModel.thumbnailUrl,
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
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final configService = Provider.of<GetConfigService>(context);
    PaymentConfig? paymentConfig = configService.paymentConfig();
    platform = Theme.of(context).platform;
    ToastContext().init(context);
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
                    "VideosPaid: ${(snapshot2.data?.data() as VideosPaid?)?.listVideoPaid}");
                return Scaffold(
                  body: Container(
                    color:
                        isDark! ? CustomTheme.primaryColorDark : Colors.white,
                    child: BlocProvider<MovieDetailsBloc>(
                      create: (BuildContext context) =>
                          MovieDetailsBloc(repository: Repository())
                            ..add(GetMovieDetailsEvent(
                                movieID: routes!['movieID'] ?? widget.movieID,
                                userID: ApiFirebase().uid)),
                      child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
                        builder: (context, state) {
                          if (state is MovieDetailsLoadedState) {
                            movieDetailsModel = state.movieDetails;
                            if (movieDetailsModel.isPaid == "1" &&
                                !ApiFirebase().isLogin()) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuthScreen(
                                            fromPaidScreen: true,
                                          )),
                                );
                              });
                            } else {
                              isDownloadEnable =
                                  movieDetailsModel.enableDownload.toString() ==
                                          "1"
                                      ? true
                                      : false;
                              return buildUI(context, paymentConfig,
                                  movieDetailsModel.videosId);
                              // }
                            }
                            return spinkit;
                          } else if (state is MovieDetailsErrorState) {
                            printLog(
                                "------------movie details erorr: ${state.message}");
                          }
                          return spinkit;
                        },
                      ),
                    ),
                  ),
                );
              });
        });
  }

  ///build movie screen UI
  Widget buildUI(
      BuildContext context, PaymentConfig? paymentConfig, String? videoId) {
    checkVideoPaid();
    return FutureBuilder(
      future: Repository().getAllComments(videoId),
      builder:
          (context, AsyncSnapshot<AllCommentModelList?> allCommentModelList) {
        if (allCommentModelList.connectionState == ConnectionState.none &&
            allCommentModelList.data == null) {
          print('project snapshot data is: not');
          return SliverToBoxAdapter(
            child: Container(),
          );
        }
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 330.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              image: DecorationImage(
                                image:
                                    NetworkImage(movieDetailsModel.posterUrl),
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
                                  isDark! ? Colors.black : Colors.white
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                            Row(
                              children: [
                                if (ApiFirebase().isLogin())
                                  favouriteMovie(ApiFirebase().uid, videoId),
                                SizedBox(
                                  width: 8.0,
                                ),
                                ShareApp(
                                    title: movieDetailsModel.title,
                                    color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, right: 8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: new EdgeInsets.symmetric(vertical: 10.0),
                          width: 140,
                          height: 200.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      movieDetailsModel.thumbnailUrl),
                                  fit: BoxFit.fill)),
                        ),
                        Container(
                          height: 200.0,
                          alignment: Alignment.bottomLeft,
                          margin: new EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                movieDetailsModel.title.length > 19
                                    ? movieDetailsModel.title.substring(0, 20) +
                                        "..."
                                    : movieDetailsModel.title,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              HelpMe().space(8),
                              Container(
                                height: 15,
                                width: MediaQuery.of(context).size.width - 170,
                                child: ListView.builder(
                                    itemCount:
                                        movieDetailsModel.genre!.length > 2
                                            ? 2
                                            : movieDetailsModel.genre!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          child: Text(
                                        index + 1 ==
                                                movieDetailsModel.genre!.length
                                            ? movieDetailsModel.genre!
                                                .elementAt(index)
                                                .name!
                                            : movieDetailsModel.genre!
                                                    .elementAt(index)
                                                    .name! +
                                                ", ",
                                        style: CustomTheme.bodyText3White,
                                      ));
                                    }),
                              ),
                              HelpMe().space(8),

                              ///Học ngay button
                              if (isUserValidSubscriber ||
                                  listVideosPaid.any((element) =>
                                      (element.videoId.toString() ==
                                              movieDetailsModel.videosId &&
                                          element.numberCanWatch != 0)) ||
                                  movieDetailsModel.isPaid == "0" || isIos)
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 170,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomTheme.primaryColorRed,
                                    ),
                                    onPressed: () {
                                      SelectServerDialog().createDialog(
                                          context,
                                          movieDetailsModel.title,
                                          movieDetailsModel.videos!,
                                          isDark);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14.0, horizontal: 10.0),
                                      child: Text(AppContent.watchNow,
                                          style: CustomTheme.bodyText3White),
                                    ),
                                  ),
                                ),

                              ///mua button
                              if (!isIos && (movieDetailsModel.isPaid == "1" &&
                                  !(isUserValidSubscriber ||
                                      listVideosPaid.any((element) =>
                                          element.videoId.toString() ==
                                              movieDetailsModel.videosId &&
                                          element.numberCanWatch != 0))))
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 170,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomTheme.primaryColorRed,
                                    ),
                                    onPressed: () {
                                      SelectMethodPaymentDialog().createDialog(
                                          context,

                                              "video don: ${movieDetailsModel.videosId}",
                                          int.parse(movieDetailsModel.videosId),
                                          (movieDetailsModel.numberCanWatch ??
                                              -1),
                                          (movieDetailsModel.price! > 0
                                              ? movieDetailsModel.price!
                                              : 10000),
                                          isDark);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 4.0),
                                      child: Text(
                                        "Mua ngay chỉ với ${PriceConverter.convertPrice(movieDetailsModel.price! > 0 ? movieDetailsModel.price! : 10000)}đ\n${movieDetailsModel.numberCanWatch == -1 ? 'Vĩnh viễn' : '${movieDetailsModel.numberCanWatch} lượt xem'}",
                                        style: CustomTheme.bodyText3White,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),

                              //rent button
                              if (movieDetailsModel.trailerUrl?.isNotEmpty ==
                                  true)
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 170,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      KochavaTracker.instance.sendEvent(
                                          "Số lượt xem thử ${movieDetailsModel.title}");
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             MovieDetailsYoutubePlayer(
                                      //                 url: movieDetailsModel
                                      //                     .trailerUrl)));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailsVideoPlayerWidget(
                                                    videoUrl: movieDetailsModel.trailerUrl,
                                                    videoMirror: movieDetailsModel.trailerUrl,
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomTheme.whiteColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14.0, horizontal: 10.0),
                                      child: Text("Xem thử",
                                          style: CustomTheme.bodyText3),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20.0,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(movieDetailsModel.description,
                    style: isDark!
                        ? CustomTheme.bodyText2White
                        : CustomTheme.bodyText2),
              ),
            ),
            if (movieDetailsModel.director!.length > 0)
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppContent.director,
                        style: isDark!
                            ? CustomTheme.bodyText1BoldWhite
                            : CustomTheme.bodyText1Bold)),
              ),
            if (movieDetailsModel.director!.length > 0)
              SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    movieDetailsModel.director!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Text(
                        index + 1 == movieDetailsModel.director!.length
                            ? movieDetailsModel.director!.elementAt(index).name!
                            : movieDetailsModel.director!
                                    .elementAt(index)
                                    .name! +
                                ", ",
                        style: isDark!
                            ? CustomTheme.bodyText2White
                            : CustomTheme.bodyText2,
                      )),
                    ),
                  ).toList(),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "${AppContent.releaseOn} ${movieDetailsModel.release}",
                    style: isDark!
                        ? CustomTheme.bodyText2White
                        : CustomTheme.bodyText2),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  AppContent.genre,
                  style: isDark!
                      ? CustomTheme.bodyText2White
                      : CustomTheme.bodyText2,
                ),
              ),
            ),
            if (movieDetailsModel.genre!.length > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Container(
                    height: 20,
                    child: ListView.builder(
                        itemCount: movieDetailsModel.genre!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: Text(
                            index + 1 == movieDetailsModel.genre!.length
                                ? movieDetailsModel.genre!
                                    .elementAt(index)
                                    .name!
                                : movieDetailsModel.genre!
                                        .elementAt(index)
                                        .name! +
                                    ", ",
                            style: CustomTheme.smallTextGrey,
                          ));
                        }),
                  ),
                ),
              ),
            if (movieDetailsModel.castAndCrew!.length > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Text(AppContent.castCrew,
                      style: isDark!
                          ? CustomTheme.bodyText2White
                          : CustomTheme.bodyText2),
                ),
              ),
            if (movieDetailsModel.castAndCrew!.length > 0)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 6.0),
                  height: 120.0,
                  child: ListView.builder(
                      itemCount: movieDetailsModel.castAndCrew!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return CastCrewCard(
                            castAndCrew:
                                movieDetailsModel.castAndCrew!.elementAt(index),
                            isDark: isDark);
                      }),
                ),
              ),
            //related movies
            if (movieDetailsModel.relatedMovie!.length > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                  child: Text(AppContent.youMayAlsoLike,
                      style: isDark!
                          ? CustomTheme.bodyText2White
                          : CustomTheme.bodyText2),
                ),
              ),
            if (movieDetailsModel.relatedMovie!.length > 0)
              SliverToBoxAdapter(
                child: Container(
                    height: 200,
                    margin: EdgeInsets.only(top: 2, bottom: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: movieDetailsModel.relatedMovie!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => MoviePoster(
                          movie: movieDetailsModel.relatedMovie![index],
                          isDark: isDark!),
                    )),
              ),

            //todo comment text
            // comment
            if (FirebaseAuth.instance.currentUser != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppContent.comments,
                    style: isDark!
                        ? CustomTheme.bodyText2White
                        : CustomTheme.bodyText2,
                  ),
                ),
              ),
            //todo box comment
            if (FirebaseAuth.instance.currentUser != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: commentsController,
                    style: isDark!
                        ? CustomTheme.bodyText2White
                        : CustomTheme.bodyText2,
                    decoration: InputDecoration(
                      hintText: AppContent.yourComments,
                      filled: true,
                      hintStyle: CustomTheme.bodyTextgray2,
                      fillColor:
                          isDark! ? Colors.black54 : Colors.grey.shade200,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 0.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 0.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 0.0),
                      ),
                    ),
                  ),
                ),
              ),
            //todo add comment
            if (FirebaseAuth.instance.currentUser != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark!
                            ? CustomTheme.grey_transparent2
                            : Colors.grey.shade300,
                      ),
                      onPressed: () async {
                        String comments = commentsController.text.toString();
                        AddCommentsModel? addCommentsModel = await Repository()
                            .addComments(
                                movieDetailsModel.videosId,
                                ApiFirebase().uid,
                                comments,
                                FirebaseAuth
                                        .instance.currentUser?.displayName ??
                                    FirebaseAuth.instance.currentUser?.email
                                        ?.replaceAll("@gmail.com", "") ??
                                    "IDANCE User");
                        print("CommentStatus: $addCommentsModel");
                        commentsController.clear();
                        if (addCommentsModel != null) {
                          showShortToast(addCommentsModel.message!, context);
                          setState(() {});
                        }
                      },
                      child: Text(AppContent.addComments,
                          style: TextStyle(color: CustomTheme.primaryColor)),
                    ),
                  ),
                ),
              ),
            if (allCommentModelList.data != null)
              SliverList(
                  delegate: SliverChildListDelegate(List.generate(
                allCommentModelList.data!.commentsList!.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Card(
                    color: isDark! ? CustomTheme.colorAccentDark : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            child: Image.network(
                              allCommentModelList.data!.commentsList!
                                          .elementAt(index)
                                          .userImgUrl !=
                                      null
                                  ? allCommentModelList.data!.commentsList!
                                      .elementAt(index)
                                      .userImgUrl!
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
                                  allCommentModelList.data!.commentsList!
                                          .elementAt(index)
                                          .userName ??
                                      "IDANCE User",
                                  style: isDark!
                                      ? CustomTheme.bodyText2White
                                      : CustomTheme.bodyTextgray2,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  allCommentModelList.data!.commentsList!
                                      .elementAt(index)
                                      .comments!,
                                  style: CustomTheme.smallTextGrey,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MovieReplyScreen.route,
                                          arguments: {
                                            'commentsID': allCommentModelList
                                                .data!.commentsList!
                                                .elementAt(index)
                                                .commentsId,
                                            'videosID': allCommentModelList
                                                .data!.commentsList!
                                                .elementAt(index)
                                                .videosId,
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
                ),
              ).toList())),
          ],
        );
      },
    );
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
          width: MediaQuery.of(context).size.width,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  AppContent.youNeedPremium,
                  style: CustomTheme.authTitle,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomTheme.primaryColor,
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PremiumSubscriptionScreen()),
                        );
                      },
                      child: Text(
                        AppContent.subscribeToPremium,
                        style: CustomTheme.bodyText3White,
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomTheme.primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppContent.goBack,
                          style: CustomTheme.bodyText3White),
                    ),
                    Spacer(
                      flex: 1,
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

  ///check device permission
  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Widget featureList(String featureTitle) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: CustomTheme.primaryColor,
        ),
        _space(width: 6.0),
      ],
    );
  }

  bool isFavoriteMovie = false;

  //make favourite
  Widget favouriteMovie(String? userID, String? movieID) {
    return FutureBuilder<FavouriteResponseModel?>(
      future: Repository().verifyFavourite(userID, movieID), // async work
      builder: (BuildContext context,
          AsyncSnapshot<FavouriteResponseModel?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (snapshot.hasData)
              return (snapshot.data!.status == "success" && !isFavoriteMovie)
                  ? IconButton(
                      onPressed: () async {
                        await (Repository()
                            .removeFavourite(userID, movieID)
                            .then((value) {
                          showShortToast(value!.message!, context);
                          setState(() {
                            isFavoriteMovie = true;
                          });
                        }) as FutureOr<FavouriteResponseModel>);
                      },
                      icon: Icon(Icons.favorite_outlined,
                          color: CustomTheme.primaryColorRed))
                  : IconButton(
                      onPressed: () async {
                        await (Repository()
                            .addFavourite(userID, movieID)
                            .then((value) {
                          showShortToast(value!.message!, context);
                          setState(() {
                            isFavoriteMovie = false;
                          });
                        }) as FutureOr<FavouriteResponseModel>);
                      },
                      icon: Icon(Icons.favorite_border,
                          color: CustomTheme.whiteColor));
            return Container();
        }
      },
    );
  }

  _space({double height = 0.0, double width = 0.0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
