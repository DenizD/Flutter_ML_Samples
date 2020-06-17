import 'package:flutter/material.dart';

class CustomListTileButton extends StatelessWidget {
  final bool isVisible;
  final Color color;
  final IconData iconData;
  final String text;
  final Function onPressed;
  CustomListTileButton(
      {this.isVisible, this.color, this.iconData, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Expanded(
        child: SizedBox(
          width: double.infinity,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            color: color,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
