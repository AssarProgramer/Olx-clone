import 'dart:ui';

import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff343634),
      appBar: AppBar(
        elevation: 0.0,
        title: Text('About Vamoos'),
        leading: Icon(Icons.arrow_back),
      ),
      body: ListView(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Us:',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'and text translations in all languages. The free translator app has overcome the language barrier for business, travelers, and education far and wide.\n \nterms and conditions, as may be amended formAccess to the Vamoos service is based on full disclosure of number of passengers carried annually, measured immediately prior to the service commencing or being immediately prior to the',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
