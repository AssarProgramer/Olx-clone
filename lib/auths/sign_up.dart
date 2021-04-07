import 'dart:io';
import 'dart:ui';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wapar/auths/sign_in.dart';
import 'package:wapar/provider/auth_provider/auth_provider.dart';
import 'package:wapar/widgets/costom_button.dart';
import 'package:wapar/widgets/costom_text_button.dart';
import 'package:wapar/widgets/costom_text_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  AuthProdiver authProdiver;

  bool isLodding = false;
  var alert;

  File _image;
  getImage({ImageSource source}) async {
    PickedFile image = await ImagePicker().getImage(
      source: source,
      imageQuality: 50,
    );
    setState(() {
      _image = File(image.path);
    });
  }


  Widget _buildTopPart() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: ClayContainer(
              spread: 3,
              borderRadius: 50,
              color: Theme.of(context).primaryColor,
              child: CircleAvatar(
                backgroundImage: _image == null
                    ? NetworkImage(
                        '',
                      )
                    : FileImage(
                        _image,
                      ),
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                child: _image == null
                    ? Text(
                        'Add Image',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      )
                    : Container(),
              ),
            ),
            onTap: () {
              alert = AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                title: new Text(
                  "SELECT",style: TextStyle(color: Theme.of(context).accentColor)
                ),
                content: new Text(
                  "your choice",style: TextStyle(color:Theme.of(context).accentColor)
                ),
                elevation: 30,
                actions: <Widget>[
                  new MaterialButton(
                    child: new Text("Gallery",style: TextStyle(color:Theme.of(context).accentColor),),
                    onPressed: () async {
                      await getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                  new MaterialButton(
                    child: Text("Camera",style: TextStyle(color:Theme.of(context).accentColor)),
                    onPressed: () async {
                      await getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          ),
          // SizedBox(
          //   width: 10,
          //   height: 10,
          // ),
          // ClayText(
          //   "Welcome aboard.",
          //   emboss: true,
          //   size: 25,
          //   textColor: Theme.of(context).accentColor,
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildBottomPart(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ClayContainer(
            height: 450,
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            depth: 40,
            spread: 10,
            borderRadius: 30,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CostomTextField(
                    passwordShot: false,
                    hitText: 'Full Name',
                    controller: fullName,
                  ),
                  CostomTextField(
                    passwordShot: false,
                    hitText: 'Email',
                    controller: email,
                  ),
                  CostomTextField(
                    controller: password,
                    passwordShot: true,
                    hitText: 'password',
                  ),
                  CostomButton(
                    onTap: () {
                      authProdiver.checkSignUpValid(
                        context: context,
                        email: email,
                        fullName: fullName,
                        image: _image,
                        password: password,
                        isLoadding: isLodding,
                      );
                    },
                    title: 'Submit',
                  ),
                  CostomTextButton(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    },
                    title: 'Already have an account?',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    authProdiver = Provider.of<AuthProdiver>(context);
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: isLodding == false
            ? ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        _buildTopPart(),
                        _buildBottomPart(context),
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }
}
