import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wapar/screens/home_screen.dart';
import 'package:wapar/widgets/contact_text_field.dart';
import 'package:wapar/widgets/my_text_field.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final yourName = TextEditingController();
  final yourEmail = TextEditingController();
  final sendYourMessage = TextEditingController();
  GlobalKey<ScaffoldState> myKey = GlobalKey<ScaffoldState>();

  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final RegExp regex = RegExp(pattern);

  void sendMessage() async {
    await FirebaseFirestore.instance.collection('UserMail').doc().set(
      {
        'userName': yourName.text,
        'userEmail': yourEmail.text,
        'userMessage': sendYourMessage.text,
      },
    );

    sendYourMessage.clear();
    yourEmail.clear();
    yourName.clear();
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Send Your Mail'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void checkValid() {
    if (yourName.text.isEmpty &&
        yourEmail.text.isEmpty &&
        sendYourMessage.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Flied Are Empty"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (yourName.text.length < 3) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Must Be 3 "),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (yourEmail.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (!regex.hasMatch(yourEmail.text)) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Try Vaild Email"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else {
      sendMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkValid();
        },
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Send Mail',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  isMode: false,
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                MyTextField(
                  controller: yourName,
                  hitText: 'Your Name',
                  obscureText: false,
                ),
                MyTextField(
                  controller: yourEmail,
                  hitText: 'Your Email',
                  obscureText: false,
                ),
                ContactTextField(
                  controller: sendYourMessage,
                  hitText: 'Send Mail',
                  maxlines: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
