import 'package:flutter/material.dart';

class raisedButton extends StatelessWidget {
  final Widget widget;
  final String btnText;
  final Function onPressed;
  final Color btnColor;
  final Color btnTextColor;

  const raisedButton({
    Key key,
    this.widget,
    this.btnText,
    this.onPressed, this.btnColor, this.btnTextColor = Colors.white,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        disabledColor: Theme.of(context).buttonColor.withOpacity(0.5),
        onPressed: onPressed,
        textColor: btnTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: btnColor ?? Theme.of(context).primaryColor,
        child:
            widget ?? Text(btnText,));
  }
}

class flatButton extends StatelessWidget {
  final Widget widget;
  final String btnText;
  final Function onPressed;
  final Color btnColor;
  final Color borderColor;
  final double borderRadius;

  const flatButton({
    Key key,
    this.widget,
    this.btnText,
    this.onPressed, this.btnColor = Colors.white, this.borderRadius = 10.0, this.borderColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        disabledColor: Theme.of(context).buttonColor.withOpacity(0.5),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5, color: borderColor ?? Theme.of(context).buttonColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: btnColor,
        textColor: Theme.of(context).buttonColor,
        child:
            widget ?? Text(btnText));
  }
}
