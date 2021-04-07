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
              // userPhoneNumber: userData.data()['userPhoneNumber'],
              // userFullAddress: userData.data()['userFullAddress'],
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
        
          userImage: '',
        );
  }

  // void checkUpdate(String fullName, String email, String password,
  //     String phoneNumber, String fullAddress,var imageMap,var isEdit,var image) async {
  //   isEdit = false;

  //   image != null ? imageMap = await _uploadFile(image) : Container();
  //   await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
  //     "userImage": image == null ? widget.currentUser.userImage : imageMap,
  //     'userFullName': fullName,
  //     'userEmail': email,
  //     'userPassword': password,
  //     'userPhoneNumber': phoneNumber,
  //     'userFullAddress': fullAddress,
  //   });
  //   notifyListeners();
  // }

   updateProfile({
    String userfullName,
    String userImage,
    String userEmail,
    String password,
  }) async {
    User currentUser = FirebaseAuth.instance.currentUser;
  
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .update(
      {
        'userImage': userImage,
        'userFullName': userfullName,
        'userEmail':userEmail,
        'userPassword':password
      }
    );
    notifyListeners();
  }

  bool isEdit = false;

  void getIsEdit(bool edit) {
    isEdit = edit;
    notifyListeners();
  }
}
