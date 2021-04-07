import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';

class CostomButton extends StatelessWidget {
  final Function onTap;
  final String title;
  CostomButton({this.onTap,this.title});
  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      width: 250,
      height: 56,
      borderRadius: 50,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: onTap,
        color:  Theme.of(context).accentColor,
        child: ClayText(title),
      ),
    );
  }
}
