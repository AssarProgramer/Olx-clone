import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wapar/drawer_side/admin/admin_screen.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/screens/home_screen.dart';

class DeleteProductScreen extends StatefulWidget {
  @override
  _DeleteProductScreenState createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  User user;

  MyProvider myProvider;
  List<ProductModel> productList;
  double height;
  Size size;
  double width;
  Widget fristExpanded(ctx, index) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(ctx).primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: fristExpanedColumn(
          ctx,
          index,
        ),
      ),
    );
  }

  Widget fristExpanedColumn(ctx, index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 4),
              height: height / 8.2,
              width: width / 3.5,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(productList[index].productImage),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    productList[index].productName,
                    style: TextStyle(
                        color: Theme.of(ctx).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    productList[index].productType,
                    style: TextStyle(
                      color: Theme.of(ctx).accentColor,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    productList[index].productPrice,
                    style: TextStyle(
                        color: Theme.of(ctx).accentColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget secound(ctx, index) {
    var alert;
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(ctx).accentColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.create, color: Colors.grey),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      ProductModel productModel = ProductModel(
                        productId: productList[index].productId,
                        userId: productList[index].userId,
                        productImagePath: productList[index].productImagePath,
                        productImage: productList[index].productImage,
                        productTime: productList[index].productTime,
                        productType: productList[index].productType,
                        productName: productList[index].productName,
                        productAddress: productList[index].productAddress,
                        productCompany: productList[index].productCompany,
                        productDescription:
                            productList[index].productDescription,
                        productModel: productList[index].productModel,
                        productPhoneNumber:
                            productList[index].productPhoneNumber,
                        productPrice: productList[index].productPrice,
                      );
                      return AdminScreen(
                        productModel,
                        1,
                      );
                    },
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              onPressed: () {
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
                      new TextButton(
                        child: new Text("Cancel"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                      new TextButton(
                        child: Text("Delete"),
                        onPressed: () async {
                          myProvider.deleteProduct(productList[index].productId, productList[index].productImagePath);

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
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
            ),
          ],
        ),
      ),
    );
  }

  getUserId() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    myProvider = Provider.of<MyProvider>(context);
    productList = myProvider.getProductList;
    return ListView(
      children: [
        productList.isNotEmpty
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (ctx, index) {
                    if (user.uid == productList[index].userId) {
                      return Container(
                        height: height / 7,
                        child: Row(
                          children: [
                            fristExpanded(
                              ctx,
                              index,
                            ),
                            secound(
                              ctx,
                              index,
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              )
            : Center(
                child: Text(
                  "No Data",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
      ],
    );
  }
}
