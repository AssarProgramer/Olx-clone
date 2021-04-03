import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wapar/auths/sign_up_screen.dart';
import 'package:wapar/provider/auth_provider/auth_provider.dart';
import 'package:wapar/widgets/my_button.dart';
import 'package:wapar/widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  final RegExp regex = RegExp(LoginScreen.pattern);

  bool isLoeading = false;
  AuthProdiver authProdiver;

  Widget topPart(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Get the best form our app',
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget secoundPart(context) {
    return Container(
      child: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: isLoeading == false
                ? MyButton(
                    name: 'Login',
                    onPressed: () {
                      authProdiver.checkLoginValid(
                        context: context,
                        password: password,
                        email: email,
                        loadding: isLoeading,
                      );
                    },
                  )
                : CircularProgressIndicator(),
          ), 
        ],
      ),
    );
  }

  Widget endPart(context) {
    return Row(
      children: [
        Text(
          'Dont\'t have an account',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ),
            );
          },
          child: Text(
            'Sign Up',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topPart(context),
                SizedBox(
                  height: height / 60,
                ),
                secoundPart(context),
                endPart(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
