import 'package:flutter/material.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/widgets/conteiner_Text_Field.dart';
import 'package:wapar/widgets/my_button.dart';
import 'package:wapar/widgets/my_text_field.dart';

class ProfileEdit extends StatefulWidget {
  final UserModel currentUser;
  var checkUpdate;

  ProfileEdit({this.currentUser, this.checkUpdate});
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();

  TextEditingController fullAddress = TextEditingController();

  final RegExp regex = RegExp(ProfileEdit.pattern);

  @override
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
    phoneNumber = TextEditingController(
      text: widget.currentUser.userPhoneNumber,
    );
    fullAddress = TextEditingController(
      text: widget.currentUser.userFullAddress,
    );
  }

  void checkValid(context) {
    if (fullName.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        fullAddress.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Flied Are Empty"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (email.text.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (!regex.hasMatch(email.text)) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Try Vaild Email"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (password.text.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (password.text.length < 8) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (phoneNumber.text.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("phoneNumber  Is Empty"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (phoneNumber.text.length < 11) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("phoneNumber  Is Must Bi 11"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (fullAddress.text.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("fullAddress  Is Empty"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else {
      widget.checkUpdate(
        fullName.text,
        email.text,
        password.text,
        phoneNumber.text,
        fullAddress.text,
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
            children: [
              MyTextField(
                hitText: 'Full Name',
                controller: fullName,
                obscureText: false,
              ),
              ContainerTextField(title: widget.currentUser.userEmail),
              // MyTextField(
              //   hitText: 'email',
              //   controller: email,
              //   obscureText: false,
              // ),
              // MyTextField(
              //   hitText: 'Password',
              //   controller: password,
              //   obscureText: true,
              // ),
              MyTextField(
                hitText: 'PhoneNumber',
                controller: phoneNumber,
                obscureText: false,
              ),
              MyTextField(
                hitText: 'Address',
                controller: fullAddress,
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                name: 'Update',
                onPressed: () {
                  setState(() {
                    checkValid(context);
                  });
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
    return textField(context);
  }
}
