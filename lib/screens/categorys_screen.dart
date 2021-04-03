import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/provider/categories_provider/categories_provider.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/screens/category_search.dart';
import 'package:wapar/screens/detile_screen.dart';
import 'package:wapar/screens/home_screen.dart';
import 'package:wapar/widgets/singal_product.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoriesProvider myProvider;
    myProvider = Provider.of<CategoriesProvider>(context);

    List<ProductModel> categoryLists = myProvider.categoryList;
    String formatted;

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,
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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CategoeySearch(
                  hintText: 'Type Product Name',
                  formatted: formatted,
                ),
              );
            },
          )
        ],
      ),
      body: categoryLists.isNotEmpty
          ? GridView.builder(
            padding: EdgeInsets.only(top: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
            ),
            itemCount: categoryLists.length,
            itemBuilder: (context, index) {
              Timestamp timeStamp = categoryLists[index].productTime;
              var nowTime = timeStamp.millisecondsSinceEpoch;
              formatted = formatTime(nowTime);
              return SingalProduct(
                singalProductImage:
                    categoryLists[index].productImage,
                singalProductName:
                    categoryLists[index].productName,
                singalProductPrice:
                    categoryLists[index].productPrice,
                singalProductType:
                    categoryLists[index].productType,
                singalProductTime: formatted,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DetileScreen(
                        productTime: formatted.toString(),
                        productAddress:
                            categoryLists[index].productAddress,
                        productCompany:
                            categoryLists[index].productCompany,
                        productDescription: categoryLists[index]
                            .productDescription,
                        productModel:
                            categoryLists[index].productModel,
                        productName:
                            categoryLists[index].productName,
                        productPhoneNumber: categoryLists[index]
                            .productPhoneNumber,
                        productPrice:
                            categoryLists[index].productPrice,
                        productType:
                            categoryLists[index].productType,
                        productImage:
                            categoryLists[index].productImage,
                      ),
                    ),
                  );
                },
              );
            },
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
    );
  }
}
