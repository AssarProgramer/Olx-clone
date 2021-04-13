import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/provider/profile_provider/profile_provider.dart';
import 'package:wapar/screens/home_screen.dart';

import 'package:wapar/widgets/costom_text_field.dart';
import 'package:wapar/widgets/my_button.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel currentUser;
  ProfileScreen({this.currentUser});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEdit = false;
  File _image;
  User user = FirebaseAuth.instance.currentUser;
  ProfileProvider profileProvider;
  Widget falseImage() {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 55,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _image == null
                ? NetworkImage(
                    widget.currentUser.userImage ?? '',
                  )
                : FileImage(
                    _image,
                  ),
            radius: 52,
          ),
        ),
      ],
    );
  }

  // void _changePassword() async {
  //   //Create an instance of the current user.
  //   User user = await FirebaseAuth.instance.currentUser;
  //   //Pass in the password to updatePassword.
  //   // user.updateEmail('baloch@gmail.com').then((value) {}).catchError((error) {
  //   //   print("Password can't be changed" + error.toString());
  //   //   //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
  //   // });
  // }

  Future resetEmail({newEmail}) async {
    var message;
    User firebaseUser = FirebaseAuth.instance.currentUser;
    firebaseUser
        .updateEmail(newEmail)
        .then(
          (value) => message = 'Success',
        )
        .catchError((onError) => message = 'error');
    return message;
  }

  Future resetPassword({newPassword}) async {
    var message;
    User firebaseUser = FirebaseAuth.instance.currentUser;
    firebaseUser
        .updatePassword(newPassword)
        .then(
          (value) => message = 'Success',
        )
        .catchError((onError) => message = 'error');
    return message;
  }

  Widget trueImage(context) {
    var alert;
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 55,
          child: GestureDetector(
            onTap: () {
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: alert = AlertDialog(
                  title: new Text(
                    "SELECT",
                  ),
                  content: new Text(
                    "your choice",
                  ),
                  actions: <Widget>[
                    new MaterialButton(
                      child: new Text("Gallery"),
                      onPressed: () async {
                        await getImage(source: ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                    new MaterialButton(
                      child: Text("Camera"),
                      onPressed: () async {
                        await getImage(source: ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: _image == null
                  ? NetworkImage(
                      widget.currentUser.userImage ?? '',
                    )
                  : FileImage(
                      _image,
                    ),
              radius: 52,
            ),
          ),
        ),
      ],
    );
  }

  Widget topPart(context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: trueImage(context)),
        ],
      ),
    );
  }

  var imageUrl;

  Future<void> _uploadFile(File _image) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('${user.uid}.jpg');
    var uploadTask = storageReference.putFile(_image);
    var task = await uploadTask;

    await task.ref.getDownloadURL().then(
          (imageURL) => {
            imageUrl = imageURL,
          },
        );
  }

  Future getImage({ImageSource source}) async {
    var pickedImage = await ImagePicker().getImage(
      source: source,
      imageQuality: 25,
    );
    setState(() {
      _image = File(pickedImage.path);
    });
    await _uploadFile(_image);
  }

  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();

  TextEditingController fullAddress = TextEditingController();
  @override
  var profileImage;
  void initState() {
    super.initState();
    fullName = TextEditingController(
      text: widget.currentUser.userFullName,
    );
    email = TextEditingController(
      text: widget.currentUser.userEmail,
    );
    password = TextEditingController(
      text: widget.currentUser.userPassword,
    );
  }

  var changepassword;
  var changeEmails;

  checkValid(context, imageUrl) async {
    if (fullName.text.isEmpty) {
      print('sadsa');
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Full Name Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (email.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("email Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else if (password.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("password Is Empty"),
              backgroundColor: Theme.of(context).errorColor,
            );
          });
    } else {
      if (imageUrl == null) {
        await profileProvider.updateProfile(
          userfullName: fullName.text,
          password: password.text,
          userImage: widget.currentUser.userImage,
          userEmail: email.text,
        );
      } else {
        await profileProvider.updateProfile(
          userfullName: fullName.text,
          password: password.text,
          userImage: imageUrl,
          userEmail: email.text,
        );
      }
      if (changeEmails != null) {
        resetEmail(newEmail: changeEmails);
      } else if (changepassword == null) {
        resetPassword(newPassword: changepassword);
      }

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  Widget textField(context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CostomTextField(
                controller: fullName,
                passwordShot: false,
                hitText: 'Full Name',
              ),
              SizedBox(
                height: 30,
              ),
              CostomTextField(
                controller: email,
                passwordShot: false,
                hitText: 'email',
                onChange: (email) {
                  changeEmails = email;
                  print(email);
                },
              ),
              SizedBox(
                height: 30,
              ),
              CostomTextField(
                controller: password,
                passwordShot: false,
                hitText: 'password',
                onChange: (password) {
                  changepassword = password;
                },
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                name: 'Update',
                onPressed: () async {
                  // if (imageUrl == null) {
                  checkValid(context, imageUrl);
                  //   Navigator.of(context).pop();
                  // } else {
                  // Navigator.of(context).pop();
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: profileProvider.isEdit == false
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
              )
            : IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  profileProvider.getIsEdit(false);
                },
              ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          topPart(context),
          SizedBox(
            height: height / 10,
          ),
          textField(context),
        ],
      ),
    );
  }
}
