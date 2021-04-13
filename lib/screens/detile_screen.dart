import 'package:clay_containers/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wapar/screens/home_screen.dart';

class DetileScreen extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productDescription;
  final String productAddress;
  final String productCompany;
  final String productModel;
  final String productPhoneNumber;
  final String productType;
  final String productPrice;
  final String productTime;
  final String userName;

  DetileScreen({
    @required this.userName,
    @required this.productTime,
    @required this.productImage,
    @required this.productType,
    @required this.productName,
    @required this.productAddress,
    @required this.productCompany,
    @required this.productDescription,
    @required this.productModel,
    @required this.productPhoneNumber,
    @required this.productPrice,
  });
  @override
  double height;
  double width;
  Size size;

  Widget detile(context, {String leading, String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leading,
            style: TextStyle(
              color: Colors.indigo[300],
              fontSize: 17,
            ),
          ),
          SizedBox(
            width: 40,
          ),
          Text(
            title,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget detileContainer(context) {
    return ClayContainer(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      depth: 40,
      spread: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        color: Theme.of(context).primaryColor,
        height: height / 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail',
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            detile(
              context,
              leading: 'Model',
              title: productModel,
            ),
            detile(
              context,
              leading: 'Condiction',
              title: productType,
            ),
          ],
        ),
      ),
    );
  }

  Widget secoundPart(context) {
    return ClayContainer(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      depth: 40,
      spread: 1,
      child: Container(
        padding: EdgeInsets.all(8),
        height: height / 4,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rs:$productPrice",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  productName,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 230,
                  child: Text(
                    productAddress,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Text(
                  productTime,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget discription(context) {
    return Center(
      child: ClayContainer(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        depth: 40,
        spread: 1,
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 10),
          color: Theme.of(context).primaryColor,
          height: height / 4,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  productDescription,
                  style: TextStyle(color: Colors.indigo[300], fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    User currentUser  = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 450.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Image.network(
                  productImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadding) {
                    return loadding == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ),
          ];
        },
        body: ListView(
          children: [
            secoundPart(context),
            SizedBox(
              height: 7,
            ),
            detileContainer(context),
            SizedBox(
              height: 8,
            ),
            discription(context),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                      radius: 45,
                      child: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).accentColor,
                        size: 90,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName == currentUser.displayName?'YOUR':userName,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 30,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              productPhoneNumber,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
