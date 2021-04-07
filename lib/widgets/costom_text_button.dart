import 'package:flutter/material.dart';

class CostomTextButton extends StatelessWidget {
  final Function onTap;
  final String title;
  CostomTextButton({this.onTap, this.title});
  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(color:  Theme.of(context).accentColor),
      ),
    );
  }
}
