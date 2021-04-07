import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wapar/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class AuthProdiver with ChangeNotifier {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final RegExp regex = RegExp(AuthProdiver.pattern);

// -------------------------------------  LOGIN ---------------------------------------------

  void checkSignUpValid({
    context,
    var isLoadding,
    var image,
    var fullName,
    var email,
    var password,
  }) {
    if (image == null &&
        fullName.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("All Flied Are Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (image == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Photo Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (fullName.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("FullName Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (fullName.text.length < 3) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Name must be more than 2 charater"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (email.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Email Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (!regex.hasMatch(email.text)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Please Try Vaild Email"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (password.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (password.text.length < 8) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password  Is Too Short"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    }  else {
      //    Map<String, String> requestHeaders = {
      //    'Content-type': 'application/json',
      //    'Accept': 'application/json',
      //  };
      //   var uri = "http://192.168.1.107:3000/auth/signup";
      //   http.post(
      //     Uri.parse(uri),
      //     body:json.encode({
      //       "email": email.text,
      //       "userName": fullName.text,
      //       "password": password.text,
      //       "phoneNumber": phoneNumber.text,
      //       "address": fullAddress.text
      //     }),
      //     headers: requestHeaders
      //   );

      checkSignUpVeryFaction(
          // confirmPassword: confirmPassword,
          email: email,
          context: context,
          // fullAddress: fullAddress,
          fullName: fullName,
          image: image,
          password: password,
          // phoneNumber: phoneNumber,
          isLoadding: isLoadding);
    }
  }

  void checkSignUpVeryFaction(
      {context,
      var phoneNumber,
      var fullAddress,
      var image,
      var fullName,
      var email,
      var password,
      var confirmPassword,
      var isLoadding}) async {
    UserCredential userCredential;
    try {
      isLoadding = true;
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      final ref = FirebaseStorage.instance.ref().child('user_image').child(
            userCredential.user.uid + '.jpg',
          );
      await ref.putFile(image);

      final userImage = await ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user.uid)
          .set(
        {
          'userImage': userImage,
          'userFullName': fullName.text,
          'userEmail': email.text,
          'userPassword': password.text,
          // 'userConfirmPassword': confirmPassword.text,
          // 'userPhoneNumber': phoneNumber.text,
          // 'userFullAddress': fullAddress.text,
          'userId': userCredential.user.uid
        },
      );
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      isLoadding = false;
    } catch (error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(error.message.toString()),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
      isLoadding = false;
    }
    notifyListeners();
  }

// -------------------------------------  LOGIN ---------------------------------------------

  void checkLoginValid({
    context,
    var email,
    var password,
    var loadding,
  }) {
    if (email.text.isEmpty && password.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("All Flied Are Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (email.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Email Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (!regex.hasMatch(email.text)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Please Try Vaild Email"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (password.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (password.text.length < 8) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password  Is Too Short"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else {
      checkLgoinVeryFaction(
          context: context,
          email: email,
          isLoeading: loadding,
          password: password);
    }
  }

  void checkLgoinVeryFaction({
    context,
    var email,
    var password,
    var isLoeading,
  }) async {
    try {
      isLoeading = true;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      isLoeading = false;
    } catch (error) {
      isLoeading = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(error.message.toString()),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    }
  }

  notifyListeners();
}
