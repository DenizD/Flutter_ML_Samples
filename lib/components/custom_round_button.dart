import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  final bool isVisible;
  final Color color;
  final IconData iconData;
  final Function onPressed;
  CustomRoundButton(
      {this.isVisible, this.color, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: RawMaterialButton(
        child: Icon(
          iconData,
          color: Colors.white,
          size: 30,
        ),
        fillColor: color,
        shape: CircleBorder(),
        constraints: BoxConstraints.tightFor(width: 60, height: 60),
        onPressed: onPressed,
      ),
    );
  }
}
