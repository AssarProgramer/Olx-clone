import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String hitText;
  final TextEditingController controller;
  bool obscureText = false;
  TextInputType  keybord;
  List<TextInputFormatter>inputFormatters;
  MyTextField({this.keybord,this.hitText, this.controller, this.obscureText,this.inputFormatters});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        child: TextField(
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          controller: controller,
          keyboardType: keybord,
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
