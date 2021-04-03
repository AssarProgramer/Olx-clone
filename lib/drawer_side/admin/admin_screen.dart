import 'package:flutter/material.dart';
import 'package:wapar/drawer_side/admin/add_product.dart';
import 'package:wapar/drawer_side/admin/delete_product.dart';
import 'package:wapar/drawer_side/admin/edit_product.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/screens/home_screen.dart';

class AdminScreen extends StatelessWidget {
  final ProductModel productModel;
  final int initialIndex;
  final UserModel currentUser;
  AdminScreen(
    this.productModel,
    this.initialIndex, {
    this.currentUser,
  });
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          ),
          title: Text('Admin'),
          centerTitle: true,
          elevation: 0.0,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Text('ADD')
              ),
              Tab(
                icon:Text('EDIT')
              ),
              Tab(
                icon:Text('DELETE')
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddProductScreen(currentUser: currentUser),
            EditProductScreen(productModel: productModel),
            DeleteProductScreen()
          ],
        ),
      ),
    );
  }
}
