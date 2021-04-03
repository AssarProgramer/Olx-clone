import 'package:flutter/material.dart';

class ContactTextField extends StatelessWidget {
  final String hitText;
  final TextEditingController controller;
  final int maxlines;
  ContactTextField({this.hitText, this.controller,this.maxlines});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        child: TextField(
          maxLines: maxlines,
          controller: controller,
          decoration: InputDecoration(
            fillColor: Theme.of(context).primaryColor,
            filled: true,
            hintText: hitText,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
