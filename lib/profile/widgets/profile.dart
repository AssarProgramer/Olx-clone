import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/widgets/conteiner_Text_Field.dart';

class Profile extends StatelessWidget {
  final UserModel currentUser;
  Profile({this.currentUser});

  Widget textFieldList(context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ContainerTextField(
              title: currentUser.userFullName,
            ),
            ContainerTextField(
              title: currentUser.userEmail,
            ),
            ContainerTextField(
            
              title: currentUser.userPassword,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 55,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return textFieldList(context);
  }
}
