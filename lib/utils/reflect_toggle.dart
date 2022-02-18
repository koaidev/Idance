import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxoo/widgets/movie_details_video_player.dart';

class ReflectToggle extends StatelessWidget {
  const ReflectToggle({
    Key? key,
    this.reflectChild,
    this.unreflectChild,
    this.toggleReflect1,
    this.size,
    this.color,
    this.padding,
    this.decoration,
  }) : super(key: key);

  /// Widget shown when the video is not muted.
  ///
  /// Default - Icon(Icons.volume_off)
  final Widget? reflectChild;

  /// Widget shown when the video is muted.
  ///
  /// Default - Icon(Icons.volume_up)
  final Widget? unreflectChild;

  /// Function called onTap of visible child.
  ///
  /// Default action -
  /// ``` dart
  ///    controlManager.toggleMute();
  /// ```
  final Function? toggleReflect1;

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
    Widget reflectWidget = reflectChild ??
        Icon(
          Icons.autorenew,
          size: size,
          color: color,
        );
    Widget unreflectWidget = unreflectChild ??
        Icon(
          Icons.block_rounded,
          size: size,
          color: color,
        );

    Widget child = reflectWidget;

    return GestureDetector(
        key: key,
        onTap: () {
          if (toggleReflect1 != null) {
            toggleReflect1!();
          }else{
            toggleReflect();
          }
        },
        child: Container(
          padding: padding,
          decoration: decoration,
          child: child,
        ));
  }
}
