import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

class ContainerTextField extends StatelessWidget {
  final String title;
  final String value;
  ContainerTextField({this.title, this.value});
  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      borderRadius: 30,
      spread: 1,
      color: Theme.of(context).primaryColor,
      emboss: true,
      parentColor: Theme.of(context).primaryColor,
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 7),
        height: 58.7,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 16),
              ),
              Text(
                value ?? '',
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
