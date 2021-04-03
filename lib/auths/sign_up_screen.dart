import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wapar/auths/login_screen.dart';
import 'package:wapar/provider/auth_provider/auth_provider.dart';
import 'package:wapar/widgets/my_button.dart';
import 'package:wapar/widgets/my_text_field.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confirmPassword = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();

  TextEditingController fullAddress = TextEditingController();

  AuthProdiver authProdiver;
  
  bool isLodding = false;
  var alert;

  File _image;
  getImage({ImageSource source}) async {
    PickedFile image = await ImagePicker().getImage(
      source: source,
    );
    setState(() {
      _image = File(image.path);
    });
  }

  Widget topImage(context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 45,
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
                        Navigator.of(context).pop();
                      },
                    ),
                    new MaterialButton(
                      child: Text("Camera"),
                      onPressed: () async {
                        await getImage(source: ImageSource.camera);
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
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: _image == null
                    ? NetworkImage(
                        '',
                      )
                    : FileImage(
                        _image,
                      ),
                child: _image != null
                    ? Container()
                    : Icon(
                        Icons.add,
                        size: 60,
                      ),
                radius: 42,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget topPart(context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Welcome to Wapar',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          topImage(context),
        ],
      ),
    );
  }

  Widget secoundPart(context) {
    return Container(
      child: Column(
        children: [
          MyTextField(
            hitText: 'Full Name',
            controller: fullName,
            obscureText: false,
          ),
          MyTextField(
            hitText: 'Email',
            controller: email,
            obscureText: false,
          ),
          MyTextField(
            hitText: 'password',
            controller: password,
            obscureText: true,
          ),
          MyTextField(
            hitText: 'ConfirmPassword',
            controller: confirmPassword,
            obscureText: true,
          ),
          MyTextField(
            hitText: 'Phone Number',
            controller: phoneNumber,
            keybord: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(11),
              FilteringTextInputFormatter.digitsOnly
            ],
            obscureText: false,
          ),
          MyTextField(
            hitText: 'Full Address',
            controller: fullAddress,
            obscureText: false,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: MyButton(
                name: 'Sign Up',
                onPressed: () {
                  authProdiver.checkSignUpValid(
                    confirmPassword: confirmPassword,
                    context: context,
                    email: email,
                    fullAddress: fullAddress,
                    fullName: fullName,
                    image: _image,
                    password: password,
                    phoneNumber: phoneNumber,
                    isLoadding: isLodding,
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget endPart(context) {
    return Row(
      children: [
        Text(
          'already have an account',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    authProdiver = Provider.of<AuthProdiver>(context);
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
          child: isLodding == false
              ? ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            topPart(context),
                            SizedBox(
                              height: height / 20,
                            ),
                            secoundPart(context),
                            endPart(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
