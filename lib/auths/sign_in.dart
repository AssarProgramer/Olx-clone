import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wapar/auths/sign_up.dart';
import 'package:wapar/provider/auth_provider/auth_provider.dart';
import 'package:wapar/widgets/costom_button.dart';
import 'package:wapar/widgets/costom_text_button.dart';
import 'package:wapar/widgets/costom_text_field.dart';

class SignIn extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  final RegExp regex = RegExp(SignIn.pattern);

  bool isLoeading = false;
  AuthProdiver authProdiver;

  Widget _buildBottomPart(context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ClayContainer(
              height: 359,
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
                      controller: email,
                      hitText: 'Email',
                      passwordShot: false,
                    ),
                    CostomTextField(
                      controller: password,
                      hitText: 'Password',
                      passwordShot: false,
                    ),
                    isLoeading == false
                        ? ClayContainer(
                            width: 250,
                            height: 56,
                            borderRadius: 50,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {
                                authProdiver.checkLoginValid(
                                  context: context,
                                  password: password,
                                  email: email,
                                  loadding: isLoeading,
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Center(child: CircularProgressIndicator()),
                    CostomTextButton(
                      onTap: () {},
                      title: 'Forget Password?',
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CostomButton(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignUp(),
                ),
              );
            },
            title: 'Create Account',
          ),
        ],
      ),
    );
  }

  Widget _buildTopPart() {
    return Container(
      width: double.infinity,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            child: Image.asset('images/shoes.png'),
          ),
          ClayText(
            "Hellow, How have\nyou been?",
            emboss: true,
            size: 25,
            textColor: Theme.of(context).accentColor,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    authProdiver = Provider.of<AuthProdiver>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        shrinkWrap: true,

        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _buildTopPart(),
                _buildBottomPart(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
