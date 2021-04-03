import 'package:flutter/cupertino.dart';

class UserModel {
  final String userImage;
  final String userFullName;
  final String userEmail;
  final String userPassword;
  final String userPhoneNumber;
  final String userFullAddress;

  UserModel({
    @required this.userImage,
    @required this.userEmail,
    @required this.userFullName,
    @required this.userPassword,
    @required this.userPhoneNumber,
    @required this.userFullAddress,
  });
}
