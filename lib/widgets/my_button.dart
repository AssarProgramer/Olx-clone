import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String name;
  final Function onPressed;

  MyButton({this.name,  this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
          10,
        )),
        color: Theme.of(context).accentColor,
        onPressed: onPressed,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
