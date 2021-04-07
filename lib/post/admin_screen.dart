import 'package:flutter/material.dart';
import 'package:wapar/post/add_product.dart';
import 'package:wapar/post/delete_product.dart';
import 'package:wapar/post/edit_product.dart';
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
        
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('POST'),
          centerTitle: true,
          elevation: 0.0,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Text('Add Post')
              ),
              Tab(
                icon:Text('Edit Post')
              ),
              Tab(
                icon:Text('Delete Post')
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
