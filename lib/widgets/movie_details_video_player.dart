import 'dart:ffi';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxoo/utils/reflect_toggle.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

import 'SpeedChip.dart';

bool showFront = true;

///reflect video
Future<void> reflect() async {
  showFront = true;
}

/// not reflect the video.
Future<void> notReflect() async {
  showFront = false;
}

/// Toggle reflect.
Future<void> toggleReflect() async {
  showFront ? notReflect() : reflect();
}

class MovieDetailsVideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;
  final File? localFile;
  final String? videoMirror;

  const MovieDetailsVideoPlayerWidget(
      {Key? key, this.videoUrl, this.localFile, this.videoMirror})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerState();
  }
}

class _PlayerState extends State<MovieDetailsVideoPlayerWidget> {
  late FlickManager flickManager;
  late VideoPlayerController videoPlayerController;
  late dynamic boxFit;
  bool isZoomOut = false;

  void setVideo(bool isMirror){
    if(isMirror){
      videoPlayerController = VideoPlayerController.network(widget.videoMirror!);
      videoPlayerController.initialize().then((value) => setState(() {}));
    }else{
      videoPlayerController = VideoPlayerController.network(widget.videoUrl!);
      videoPlayerController.initialize().then((value) => setState(() {}));
    }
  }

  @override
  void initState() {
   setVideo(false);
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
            // Use the VideoPlayer widget to display the video.
            child: FlickVideoPlayer(
          flickManager: flickManager,
          preferredDeviceOrientationFullscreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
          preferredDeviceOrientation: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ],
          systemUIOverlay: [],
          flickVideoWithControls: FlickVideoWithControls(
            controls: LandscapePlayerControls(playerState: this,),
            videoFit: BoxFit.fitHeight,
          ),
        )));
  }
}

class LandscapePlayerControls extends StatefulWidget {
  LandscapePlayerControls({
    Key? key,
    required this.playerState,
    this.iconSize = 20,
    this.fontSize = 12,
  }) : super(key: key);
  final double iconSize;
  final double fontSize;
  final _PlayerState playerState;

  @override
  State<LandscapePlayerControls> createState() =>
      _LandscapePlayerControlsState(playerState: playerState);
}

class _LandscapePlayerControlsState extends State<LandscapePlayerControls> {
  double speed = 1.0;

  _LandscapePlayerControlsState({required this.playerState});
  _PlayerState playerState;

  @override
  Widget build(BuildContext contextMain) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    double size = 50;
    Color color = Colors.white;
    Widget playBack10s = Icon(
      Icons.fast_rewind_rounded,
      size: size,
      color: color,
    );

    Widget playForward10s = Icon(
      Icons.fast_forward_rounded,
      size: size,
      color: color,
    );

    return Stack(
      children: <Widget>[
        FlickShowControlsAction(
          child: FlickSeekVideoAction(
            child: Center(
              child: FlickVideoBuffer(
                child: FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Row(
                        //   mainAxisSize: MainAxisSize.max,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        ReflectToggle(
                          size: 40,
                          toggleReflect1: () {
                            setState(() {
                              playerState.setVideo(true);
                            });
                          },
                        ),
                        //   ],
                        // ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controlManager
                                    .seekBackward(Duration(seconds: 10));
                              },
                              child: Column(
                                children: [playBack10s, Text("10s")],
                              ),
                            ),
                            Column(
                              children: [
                                LandscapePlayToggle(),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                controlManager
                                    .seekForward(Duration(seconds: 10));
                              },
                              child: Column(
                                children: [playForward10s, Text("10s")],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: ChipsFilter(
                              selected: getCurrentSpeed(speed),
                              // Select the second filter as default
                              filters: [
                                Filter(
                                    label: "0.5",
                                    action: () {
                                      controlManager.setPlaybackSpeed(0.5);
                                      setState(() {
                                        speed = 0.5;
                                      });
                                    }),
                                Filter(
                                    label: "0.75",
                                    action: () {
                                      controlManager.setPlaybackSpeed(0.75);
                                      setState(() {
                                        speed = 0.75;
                                      });
                                    }),
                                Filter(
                                    label: "1.0",
                                    action: () {
                                      controlManager.setPlaybackSpeed(1.0);
                                      setState(() {
                                        speed = 1.0;
                                      });
                                    }),
                                Filter(
                                    label: "1.25",
                                    action: () {
                                      controlManager.setPlaybackSpeed(1.25);
                                      setState(() {
                                        speed = 1.25;
                                      });
                                    }),
                                Filter(
                                    label: "1.5",
                                    action: () {
                                      controlManager.setPlaybackSpeed(1.5);
                                      setState(() {
                                        speed = 1.5;
                                      });
                                    }),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlickPlayToggle(
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlickCurrentPosition(
                        fontSize: widget.fontSize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: FlickVideoProgressBar(
                            flickProgressBarSettings: FlickProgressBarSettings(
                              height: 10,
                              handleRadius: 10,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.white24,
                              bufferedColor: Colors.white38,
                              getPlayedPaint: (
                                  {double? handleRadius,
                                  double? height,
                                  double? playedPart,
                                  double? width}) {
                                return Paint()
                                  ..shader = LinearGradient(colors: [
                                    Color.fromRGBO(108, 165, 242, 1),
                                    Color.fromRGBO(97, 104, 236, 1)
                                  ], stops: [
                                    0.0,
                                    0.5
                                  ]).createShader(
                                    Rect.fromPoints(
                                      Offset(0, 0),
                                      Offset(width!, 0),
                                    ),
                                  );
                              },
                              getHandlePaint: (
                                  {double? handleRadius,
                                  double? height,
                                  double? playedPart,
                                  double? width}) {
                                return Paint()
                                  ..shader = RadialGradient(
                                    colors: [
                                      Color.fromRGBO(97, 104, 236, 1),
                                      Color.fromRGBO(97, 104, 236, 1),
                                      Colors.white,
                                    ],
                                    stops: [0.0, 0.4, 0.5],
                                    radius: 0.4,
                                  ).createShader(
                                    Rect.fromCircle(
                                      center: Offset(playedPart!, height! / 2),
                                      radius: handleRadius!,
                                    ),
                                  );
                              },
                            ),
                          ),
                        ),
                      ),
                      FlickTotalDuration(
                        fontSize: widget.fontSize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlickSoundToggle(
                        size: 20,
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // ReflectToggle(
                      //   size: 20,
                      //   toggleReflect1: () {
                      //     Toast.show(
                      //         "Tính năng Gương lật đang được phát triển.",
                      //         duration: Toast.lengthShort,
                      //         gravity: Toast.center);
                      //   },
                      // ),
                      SizedBox(
                        width: 10,
                      ),
                      FlickSetPlayBack(
                        setPlayBack: () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: contextMain,
                            builder: (contextMain) {
                              return FractionallySizedBox(
                                heightFactor: 0.7,
                                child: Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // _buildItem(context, "0.25", action: () {
                                        //   controlManager.setPlaybackSpeed(0.25);
                                        //   setState(() {});
                                        //   Navigator.pop(context);
                                        // }),
                                        _buildItem(context, "0.5", action: () {
                                          controlManager.setPlaybackSpeed(0.5);
                                          setState(() {});
                                          Navigator.pop(context);
                                        }),
                                        _buildItem(context, "0.75", action: () {
                                          controlManager.setPlaybackSpeed(0.75);
                                          setState(() {});
                                          Navigator.pop(context);
                                        }),
                                        _buildItem(context, "Bình thường",
                                            action: () {
                                          controlManager.setPlaybackSpeed(1.0);
                                          setState(() {});
                                          Navigator.pop(context);
                                        }),
                                        _buildItem(context, "1.25", action: () {
                                          controlManager.setPlaybackSpeed(1.5);
                                          setState(() {});
                                          Navigator.pop(context);
                                        }),
                                        _buildItem(context, "1.5", action: () {
                                          controlManager.setPlaybackSpeed(2.0);
                                          setState(() {});
                                          Navigator.pop(context);
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // IconButton(onPressed: (){}, icon: (isZoomOut)? Icon(Icons.zoom_out_map): )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 10,
          child: GestureDetector(
            onTap: () {
              // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.pop(context);
            },
            child: Icon(
              Icons.cancel,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  int getCurrentSpeed(double speed) {
    int index = 2;
    if (speed == 0.5) {
      index = 0;
    } else if (speed == 0.75) {
      index = 1;
    } else if (speed == 1.0) {
      index = 2;
    } else if (speed == 1.25) {
      index = 3;
    } else {
      index = 4;
    }
    return index;
  }

  Widget _buildItem(BuildContext context, String title, {Function? action}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.5))),
      child: GestureDetector(
        onTap: () {
          action?.call();
        },
        child: Stack(
          children: [
            Text(title),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 20,
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}

class LandscapePlayToggle extends StatelessWidget {
  const LandscapePlayToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);

    double size = 50;
    Color color = Colors.white;

    Widget playWidget = Icon(
      Icons.play_circle_outline,
      size: size,
      color: color,
    );
    Widget pauseWidget = Icon(
      Icons.pause_circle_outline,
      size: size,
      color: color,
    );
    Widget replayWidget = Icon(
      Icons.replay,
      size: size,
      color: color,
    );

    Widget child = videoManager.isVideoEnded
        ? replayWidget
        : videoManager.isPlaying
            ? pauseWidget
            : playWidget;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: Color.fromRGBO(108, 165, 242, 0.5),
        key: key,
        onTap: () {
          videoManager.isVideoEnded
              ? controlManager.replay()
              : controlManager.togglePlay();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
