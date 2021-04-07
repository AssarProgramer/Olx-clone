import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel {
  final String productName;
  final String productDescription;
  final String productAddress;
  final String productImagePath;
  final String productCompany;
  final String productModel;
  final String productPhoneNumber;
  final String productType;
  final String productPrice;
   var productTime;
   final String userName;
  final String productImage;

  var userId;
  var productId;

  ProductModel({
    @required this.productImagePath,
    @required this.productImage,
    @required this.productTime,
    @required this.productType,
    @required this.userName,
    @required this.productName,
    @required this.productAddress,
    @required this.productCompany,
    @required this.productDescription,
    @required this.productModel,
    @required this.productPhoneNumber,
    @required this.productPrice,
    @required this.productId,
    @required this.userId,
  });
}
