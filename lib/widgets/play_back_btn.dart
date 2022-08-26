import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayerButton extends StatelessWidget {
  const CustomVideoPlayerButton(
      {Key? key,
      this.customButton,
      this.setPlayBack,
      this.speed = 1.0,
      this.size,
      this.color,
      this.padding,
      this.decoration,
      required this.context})
      : super(key: key);

  /// Widget shown when player is not in full-screen.
  ///
  /// Default - [Icon(Icons.fullscreen)]
  final Widget? customButton;

  final BuildContext context;

  /// Function called onTap of the visible child.
  ///
  /// Default action -
  /// ```dart
  ///     controlManager.toggleFullscreen();
  /// ```
  final Function? setPlayBack;

  /// Speed value of 2.0, your video will play at 2x the regular playback speed and so on.
  final double speed;

  /// Size for the default icons.
  final double? size;

  /// Color for the default icons.
  final Color? color;

  /// Padding around the visible child.
  final EdgeInsetsGeometry? padding;

  /// Decoration around the visible child.
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    Widget playBackWidget = customButton ??
        Icon(
          Icons.play_circle_outline_sharp,
          size: size,
          color: color,
        );

    Widget child = playBackWidget;

    return GestureDetector(
      key: key,
      onTap: () {
        _showPopupMenu(context);
        PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: FlickSetPlayBack(
                      speed: 0.25,
                      playBackChild: Text("0.25"),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: FlickSetPlayBack(
                      speed: 0.5,
                      playBackChild: Text("0.5"),
                    ),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: FlickSetPlayBack(
                      speed: 0.75,
                      playBackChild: Text("0.75"),
                    ),
                    value: 3,
                  ),
                  PopupMenuItem(
                    child: FlickSetPlayBack(
                      speed: 1.0,
                      playBackChild: Text("1.0"),
                    ),
                    value: 4,
                  ),
                  PopupMenuItem(
                    child: FlickSetPlayBack(
                      speed: 1.25,
                      playBackChild: Text("1.25"),
                    ),
                    value: 5,
                  ),
                  PopupMenuItem(
                    child: FlickSetPlayBack(
                      speed: 1.5,
                      playBackChild: Text("1.5"),
                    ),
                    value: 6,
                  ),
                  PopupMenuItem(
                    child: FlickSetPlayBack(
                      speed: 2.0,
                      playBackChild: Text("2.0"),
                    ),
                    value: 7,
                  ),
                ]);
      },
      child: Container(
        padding: padding,
        decoration: decoration,
        child: child,
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem(
          child: FlickSetPlayBack(
            speed: 0.25,
            playBackChild: Text("0.25"),
          ),
          value: 1,
        ),
        PopupMenuItem(
          child: FlickSetPlayBack(
            speed: 0.5,
            playBackChild: Text("0.5"),
          ),
          value: 2,
        ),
        PopupMenuItem(
          child: FlickSetPlayBack(
            speed: 0.75,
            playBackChild: Text("0.75"),
          ),
          value: 3,
        ),
        PopupMenuItem(
          child: FlickSetPlayBack(
            speed: 1.0,
            playBackChild: Text("1.0"),
          ),
          value: 4,
        ),
        PopupMenuItem(
          child: FlickSetPlayBack(
            speed: 1.25,
            playBackChild: Text("1.25"),
          ),
          value: 5,
        ),
        PopupMenuItem(
          child: FlickSetPlayBack(
            speed: 1.5,
            playBackChild: Text("1.5"),
          ),
          value: 6,
        ),
        PopupMenuItem(
          child: FlickSetPlayBack(
            speed: 2.0,
            playBackChild: Text("2.0"),
          ),
          value: 7,
        ),
      ],
      elevation: 8.0,
    );
  }
}
