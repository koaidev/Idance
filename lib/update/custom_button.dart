
import 'package:flutter/material.dart';
import 'package:oxoo/style/theme.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;
  final bool transparent;
  final EdgeInsets margin;
  final double height;
  final double width;
  final double? fontSize;
  final Color? color;
  CustomButton({this.onPressed, this.buttonText, this.transparent = false,  this.margin =  const EdgeInsets.all(0),
     this.width =1170,  this.height = 45,  this.fontSize,  this.color});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ? Theme.of(context).disabledColor : transparent
          ? Colors.transparent : color != null ? color : Theme.of(context).primaryColor,
      minimumSize: Size(width, height ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );

    return Padding(
      padding: margin,
      child: TextButton(
        onPressed: onPressed,
        style: _flatButtonStyle,
        child: Text(buttonText ??'', textAlign: TextAlign.center, style: CustomTheme.bodyText1.copyWith(
          color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          fontSize: fontSize != null ? fontSize : 16,
        )),
      ),
    );
  }
}
