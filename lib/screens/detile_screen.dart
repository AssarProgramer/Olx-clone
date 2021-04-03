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
  DetileScreen({
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
        children: [
          Text(
            leading,
            style: TextStyle(
              color:Colors.indigo[300],
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
    return Container(
      padding: EdgeInsets.only(top: 25, left: 10),
      color: Theme.of(context).primaryColor,
      height: height/4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'detail',
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
          detile(
            context,
            leading: 'PhoneNumber',
            title: productPhoneNumber,
          ),
        ],
      ),
    );
  }

  Widget secoundPart(context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: height/5,
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
              Text(
                productAddress,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
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
    );
  }

  Widget discription(context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 10),
      color: Theme.of(context).primaryColor,
      height: height/5,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              productDescription,
              style: TextStyle(color:Colors.indigo[300], fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      
      ),
      body: ListView(
        children: [
          Container(
            height: height/1.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  productImage ?? '',
                ),
              ),
            ),
          ),
          secoundPart(context),
          SizedBox(
            height: 7,
          ),
          detileContainer(context),
          SizedBox(
            height: 8,
          ),
          discription(context),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
