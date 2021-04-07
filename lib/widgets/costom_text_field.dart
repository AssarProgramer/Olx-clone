import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wapar/config/colors.dart';

class CostomTextField extends StatelessWidget {
  final String hitText;
  TextEditingController controller = TextEditingController();
  final bool passwordShot;
  TextInputType keybord;
  Function onChange;
  List<TextInputFormatter> inputFormatter;
  CostomTextField({this.onChange,this.hitText, this.passwordShot, this.controller,this.inputFormatter,this.keybord});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClayContainer(
        borderRadius: 30,
        spread: 1,
        color: Theme.of(context).primaryColor,
        emboss: true,
        parentColor: Theme.of(context).primaryColor,
        child: TextFormField(
          onChanged: onChange,
          inputFormatters: inputFormatter,
          keyboardType: keybord,
          controller: controller,
          obscureText: passwordShot,
          style: TextStyle(color: textsColor, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: hitText,
            hintStyle: TextStyle(color: textsColor
            ,fontSize: 14),
            fillColor: Theme.of(context).primaryColor,
            filled: true,
          ),
        ),
      ),
    );
  }
}
