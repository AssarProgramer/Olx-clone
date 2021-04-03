import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wapar/model/user_,model.dart';

class ProfileProvider with ChangeNotifier {
  UserModel userModel;
  getProfileData() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc((FirebaseAuth.instance.currentUser).uid)
        .get()
        .then(
          (userData) => {
            userModel = UserModel(
              userImage: userData.data()['userImage'],
              userEmail: userData.data()['userEmail'],
              userFullName: userData.data()['userFullName'],
              userPassword: userData.data()['userPassword'],
              userPhoneNumber: userData.data()['userPhoneNumber'],
              userFullAddress: userData.data()['userFullAddress'],
            ),
            notifyListeners(),
          },
        );
  }

  get getUserData {
    return userModel ??
        UserModel(
          userEmail: '',
          userFullName: '',
          userPassword: '',
          userPhoneNumber: '',
          userFullAddress: '',
          userImage: '',
        );
  }
}
