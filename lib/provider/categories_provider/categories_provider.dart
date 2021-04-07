import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:wapar/model/product_model.dart';

class CategoriesProvider with ChangeNotifier {
// ----------------------------- GetCategoys ------------------

  List<ProductModel> categoryList = [];
  ProductModel productModel;
  getCategoryData({String category}) async {
    List<ProductModel> newList = [];
    QuerySnapshot categoryData =
        await FirebaseFirestore.instance.collection('Product').get();
    categoryData.docs.forEach(
      (categorySnapShot) {
        if (categorySnapShot.data()["productCategory"] == category) {
          productModel = ProductModel(
            userName:  categorySnapShot.data()['userName'],
            productId: categorySnapShot.data()['productId'],
            userId: categorySnapShot.data()['userId'],
            productImagePath: categorySnapShot.data()["productImagePath"],
            productType: categorySnapShot.data()['productType'],
            productName: categorySnapShot.data()['productName'],
            productAddress: categorySnapShot.data()['productAddress'],
            productCompany: categorySnapShot.data()['productCompany'],
            productDescription: categorySnapShot.data()['productDescription'],
            productModel: categorySnapShot.data()['productModel'],
            productPhoneNumber: categorySnapShot.data()['productPhoneNumber'],
            productPrice: categorySnapShot.data()['productPrice'],
            productTime: categorySnapShot.data()['productTime'],
            productImage: categorySnapShot.data()['productImage'],
          );
          newList.add(productModel);
        }
      },
    );
    notifyListeners();
    categoryList = newList;
  }

  get getCategoryProductList {
    return categoryList;
  }

//  ------------------------------------ Category Search -----------------------------
  List<ProductModel> categorySearch(String category) {
    List<ProductModel> categorySearch = categoryList.where(
      (element) {
        return element.productName.toLowerCase().contains(category) ||
            element.productName.toUpperCase().contains(category);
      },
    ).toList();
    return categorySearch;
  }
}
