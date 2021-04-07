import 'package:flutter/cupertino.dart';

class UserModel {
  final String userImage;
  final String userFullName;
  final String userEmail;
  final String userPassword;


  UserModel({
    @required this.userImage,
    @required this.userEmail,
    @required this.userFullName,
    @required this.userPassword,

  });
}
