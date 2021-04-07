import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/provider/categories_provider/categories_provider.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/screens/detile_screen.dart';
import 'package:wapar/widgets/singal_product.dart';

class CategoeySearch extends SearchDelegate<ProductModel> {
  final List<ProductModel> currentUser;
  final int index;
  final String formatted;
  CategoeySearch({
    this.currentUser,
    this.formatted,
    this.index,
    String hintText = "Song Search",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          close(
            context,
            null,
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    CategoriesProvider provider = Provider.of<CategoriesProvider>(context);

    List<ProductModel> categorySearch = provider.categorySearch(query);

    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.74,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.only(top: 10),
        children: categorySearch.map<Widget>(
          (e) {
            return SingalProduct(
              singalProductImage: e.productImage,
              singalProductName: e.productName,
              singalProductTime: formatted,
              singalProductPrice: e.productPrice,
              singalProductType: e.productType,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => DetileScreen(
                      productTime: formatted,
                      productImage: e.productImage,
                      productType: e.productType,
                      productName: e.productName,
                      productAddress: e.productAddress,
                      productCompany: e.productCompany,
                      productDescription: e.productDescription,
                      productModel: e.productModel,
                      productPhoneNumber: e.productPhoneNumber,
                      productPrice: e.productPrice,
                    ),
                  ),
                );
              },
            );
          },
        ).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    CategoriesProvider provider = Provider.of<CategoriesProvider>(context);

    List<ProductModel> categorySearch = provider.categorySearch(query);

    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.74,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.only(top: 10),
        children: categorySearch.map<Widget>(
          (e) {
            return SingalProduct(
              singalProductImage: e.productImage,
              singalProductName: e.productName,
              singalProductTime: formatted,
              singalProductPrice: e.productPrice,
              singalProductType: e.productType,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => DetileScreen(
                      productTime: formatted,
                      productImage: e.productImage,
                      productType: e.productType,
                      productName: e.productName,
                      productAddress: e.productAddress,
                      productCompany: e.productCompany,
                      productDescription: e.productDescription,
                      productModel: e.productModel,
                      productPhoneNumber: e.productPhoneNumber,
                      productPrice: e.productPrice,
                    ),
                  ),
                );
              },
            );
          },
        ).toList());
  }
}
