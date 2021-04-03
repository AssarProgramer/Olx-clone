import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/screens/home_screen.dart';
import 'package:wapar/widgets/profile.dart';
import 'package:wapar/widgets/profile_edit.dart';

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

  Future<String> _uploadFile(File _camaraImage) async {
    var storageReference =
        FirebaseStorage.instance.ref().child('images/${user.uid}');
    var uploadTask = storageReference.putFile(_camaraImage);
    var task = await uploadTask;
    final String _imageUrl = (await task.ref.getDownloadURL());

    return _imageUrl;
  }

  var imageMap;

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
                    widget.currentUser.userImage,
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
                        Navigator.of(context).pop();
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
                      widget.currentUser.userImage,
                    )
                  : FileImage(
                      _image,
                    ),
              radius: 52,
              child: Text(
                'Click On',
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 17),
              ),
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
            child: isEdit == true ? trueImage(context) : falseImage(),
          ),
        ],
      ),
    );
  }

  Future getImage({ImageSource source}) async {
    var pickedImage = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  void checkUpdate(String fullName, String email, String password,
      String phoneNumber, String fullAddress) async {
    setState(() {
      isEdit = false;
    });
    _image != null ? imageMap = await _uploadFile(_image) : Container();
    await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
      "userImage": _image == null ? widget.currentUser.userImage : imageMap,
      'userFullName': fullName,
      'userEmail': email,
      'userPassword': password,
      'userPhoneNumber': phoneNumber,
      'userFullAddress': fullAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: isEdit == false
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
                  setState(() {
                    isEdit = false;
                  });
                },
              ),
        actions: [
          MaterialButton(
            onPressed: () {
              setState(() {
                isEdit = true;
              });
            },
            child: Text(
              'Edit',
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          )
        ],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          topPart(context),
          SizedBox(
            height: height / 10,
          ),
          isEdit == false
              ? Profile(
                  currentUser: widget.currentUser,
                )
              : ProfileEdit(
                  currentUser: widget.currentUser,
                  checkUpdate: checkUpdate,
                ),
        ],
      ),
    );
  }
}
