import 'package:flutter/material.dart';
import 'package:wapar/screens/home_screen.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => HomeScreen(

            ),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => HomeScreen(),
                  ),
                );
              }),
          centerTitle: true,
          title: Text("About"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Wrap(
              children: [
                Text(
                  "There was an idea to brings all people to sell and buy products consistently because we have nothing to do it by using of such like technology only way was to manual lots of resources are wasted plus some disadvantages too. This issue raised by Faseel Bugti to develop such like app to fulfill our needs.\nBasically its took me a 2months to be honest. My name is Khalil bugti designer and developer for this app. Its like hardwork to maintain this like app well you all to support me as well as possible. We all make it best than ever version to version.\nThanks for My Developers: SABEEL MIRAK, AQEEL, SABIR, YAQOOB And ASSAR \nSpecially Thanks to Mr. Abdul Kareem for Production and Also Mr.Jumma Khan to Support us",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
