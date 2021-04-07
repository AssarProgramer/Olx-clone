import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/model/user_,model.dart';

class MyProvider with ChangeNotifier {
  UserModel userModel;
  ProductModel productModel;
  List<ProductModel> productModelList = [];
  List<ProductModel> categoryList = [];
  Future<void> addProduct({
    String userName,
    String pathImage,
    String productName,
    String productDescription,
    String productAddress,
    String productCompany,
    String productModel,
    String productPhoneNumber,
    String productType,
    String productPrice,
    String productImage,
    String productCategory,
  }) async {
    var user = FirebaseAuth.instance.currentUser;

    try {
      var querySnapshot =
          FirebaseFirestore.instance.collection('Product').doc();

      querySnapshot.set(
        {
          "productCategory": productCategory,
          'userId': user.uid,
          'productId': querySnapshot.id,
          "productImagePath": pathImage,
          'productName': productName,
          'productCompany': productCompany,
          'productModel': productModel,
          'productPrice': productPrice,
          'productType': productType,
          'productAddress': productAddress,
          'productPhoneNumber': productPhoneNumber,
          'productDescription': productDescription,
          'productTime': DateTime.now().millisecondsSinceEpoch.toString(),
          'productImage': productImage,
          'userName': userName,
        },
      );
      notifyListeners();
      return null;
    } catch (error) {
      notifyListeners();
      return error;
    }
  }

//.... Update Product ..... ///

  Future<void> updataProduct({
    String pathImage,
    String productName,
    String productDescription,
    String productAddress,
    String productCompany,
    String productModel,
    String productPhoneNumber,
    String productType,
    String productPrice,
    String productImage,
    String productId,
    String userName,
  }) async {
    var user = FirebaseAuth.instance.currentUser;
    try {
      var querySnapshot =
          FirebaseFirestore.instance.collection('Product').doc(productId);

      querySnapshot.update(
        {
          'userId': user.uid,
          'productId': productId,
          "productImagePath": pathImage,
          'productName': productName,
          'productCompany': productCompany,
          'productModel': productModel,
          'productPrice': productPrice,
          'productType': productType,
          'productAddress': productAddress,
          'productPhoneNumber': productPhoneNumber,
          'productDescription': productDescription,
          'productTime': DateTime.now().millisecondsSinceEpoch.toString(),
          'productImage': productImage,
          'userName': userName,
        },
      );
      notifyListeners();
      return null;
    } catch (error) {
      notifyListeners();
      return error;
    }
  }

  getProductData() async {
    List<ProductModel> newList = [];
    QuerySnapshot productData = await FirebaseFirestore.instance
        .collection('Product')
        .orderBy('productId', descending: true,)
        .get();
    productData.docs.forEach(
      (categorySnapShot) {
        productModel = ProductModel(
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
          userName: categorySnapShot.data()['userName'],
        );
        newList.add(productModel);
      },
    );
    notifyListeners();
    productModelList = newList;
  }

  get getProductList {
    return productModelList;
  }

  Future<void> deleteProduct(String productId, String productImagePath) async {
    await deleteImage(productImagePath);
    await FirebaseFirestore.instance
        .collection('Product')
        .doc(productId)
        .delete();
    notifyListeners();
    return;
  }

  User user;
  Future<void> deleteImage(String imageFileUrl) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('product_image')
        .child(imageFileUrl);
    await storageReference.delete();

    //  await FirebaseStorage.instance
    //       .ref()
    //       .child("product_image")
    //       .child(
    //         imageFileUrl+".jpg'",
    //       )
    //       .delete()
    //       .then(
    //         (value) => print("Yes its Delete "),
    //       );
  }

  List<ProductModel> productSearch(String query) {
    List<ProductModel> productSearch = productModelList.where(
      (element) {
        return element.productName.toLowerCase().contains(query) ||
            element.productName.toUpperCase().contains(query);
      },
    ).toList();
    return productSearch;
  }

  // var color = const Color(0xFFB74093);

  // static ThemeData dark = ThemeData(
  //   accentColor: Color(0xff0056fe),
  //   scaffoldBackgroundColor: Colors.black,
  //   brightness: Brightness.dark,
  //   primaryColor: Colors.black,
  // );
  static ThemeData light = ThemeData(
    accentColor: Color(0xff479ddb),
    scaffoldBackgroundColor: HexColor('eff4ff'),
    brightness: Brightness.light,
    primaryColor: HexColor('#eff4ff'),
  );
  // final String key = "theme";
  // SharedPreferences _prefs;
  // bool _darkTheme;

  // bool get darkTheme => _darkTheme;

  // MyProvider() {
  //   _darkTheme = true;
  //   _loadFromPrefs();
  // }

  // toggleTheme() {
  //   _darkTheme = !_darkTheme;
  //   _saveToPrefs();
  // }

  // _initPrefs() async {
  //   if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  // }

  // _loadFromPrefs() async {
  //   await _initPrefs();
  //   _darkTheme = _prefs.getBool(key) ?? true;
  // }

  // _saveToPrefs() async {
  //   await _initPrefs();
  //   _prefs.setBool(key, _darkTheme);
  // }
}
