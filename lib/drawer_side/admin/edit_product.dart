import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/screens/home_screen.dart';
import 'package:wapar/widgets/my_button.dart';
import 'package:wapar/widgets/my_text_field.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel productModel;
  EditProductScreen({this.productModel});
  static Pattern phoneNumberPattern =
      r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';
  static Pattern pricePattern = r"^[0-9]+$";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  RegExp phoneRegix = new RegExp(EditProductScreen.phoneNumberPattern);
  RegExp priceRegix = new RegExp(EditProductScreen.pricePattern);
  String _productType = 'USED';
  bool isLoading = false;
  double height;
  double width;
  Size size;
  TextEditingController _productName;
  TextEditingController _productDescription;
  TextEditingController _productPrice;
  TextEditingController _productAddress;
  TextEditingController _productCompany;
  TextEditingController _productModel;
  TextEditingController _productPhoneNumber;

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      _productName =
          TextEditingController(text: widget.productModel.productName);
      _productDescription =
          TextEditingController(text: widget.productModel.productDescription);
      _productPrice =
          TextEditingController(text: widget.productModel.productPrice);
      _productAddress = TextEditingController(
        text: widget.productModel.productAddress,
      );
      _productCompany =
          TextEditingController(text: widget.productModel.productCompany);
      _productModel =
          TextEditingController(text: widget.productModel.productModel);
      _productPhoneNumber =
          TextEditingController(text: widget.productModel.productPhoneNumber);
    }
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  File _image;
  MyProvider myProvider;
  List<ProductModel> list;
  String _imageUrl, _imagePath;

  Future<void> _uploadFile(File _image) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('product_image/${widget.productModel.productImagePath}');
    var uploadTask = storageReference.putFile(_image);
    var task = await uploadTask;
    _imageUrl = await task.ref.getDownloadURL();
    _imagePath = widget.productModel.productImagePath;
  }

  var imageMap;



  void toggleProductType() {
    setState(() {
      _productType == 'USED' ? _productType = 'NEW' : _productType = "USED";
    });
  }

  void checkValid(context) {
    bool productName = _productName.text.isEmpty;
    bool productDescription = _productDescription.text.isEmpty;
    bool productPrice = _productPrice.text.isEmpty;
    bool productAddress = _productAddress.text.isEmpty;
    bool productCompany = _productCompany.text.isEmpty;
    bool productModel = _productModel.text.isEmpty;
    bool productPhoneNumber = _productPhoneNumber.text.isEmpty;
    if (productName &&
        productDescription &&
        productPrice &&
        productAddress &&
        productModel &&
        productPhoneNumber &&
        productCompany) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("All Fields are Empty"),
        ),
      );
      return;
    }

    if (productName) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Product Name is Empty"),
        ),
      );
      return;
    }
    if (_productName.text.length >= 13) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Name must be 12 characters"),
        ),
      );
      return;
    }

    if (productCompany) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Product Company is Empty"),
        ),
      );
      return;
    }

    if (_productCompany.text.length >= 13) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Company must be 12 characters"),
        ),
      );
      return;
    }

    if (productModel) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Product Model is Empty"),
        ),
      );
      return;
    }

    if (_productModel.text.length >= 13) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Model must be 12 characters"),
        ),
      );
      return;
    }

    if (productPrice) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Product Price is Empty"),
        ),
      );
      return;
    }

    if (!priceRegix.hasMatch(_productPrice.text)) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Price must be Numbers"),
        ),
      );
      return;
    }

    if (productAddress) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Product Address is Empty"),
        ),
      );
      return;
    }

    if (_productAddress.text.length >= 25) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Address must be 24 characters"),
        ),
      );
      return;
    }

    if (productDescription) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Product Description is Empty"),
        ),
      );
      return;
    }

    if (productPhoneNumber) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Phone Number is Empty"),
        ),
      );
      return;
    }

    if (!phoneRegix.hasMatch(_productPhoneNumber.text)) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Phone Number must be 11 numbers"),
        ),
      );
    } else {
      checkVeryfaction(context);
    }
  }

  Future imagePicker({ImageSource source}) async {
    PickedFile imagePicked = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(imagePicked.path);
    });
  }

  Widget usedNew(context) {
    return GestureDetector(
      onTap: () {
        toggleProductType();
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 15),
        margin: EdgeInsets.symmetric(vertical: 7),
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          _productType,
          style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

var alert;
  Widget productImage(context) {
    return GestureDetector(
      onTap: () {
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
                    new MaterialButton(
                      child: new Text("Gallery"),
                      onPressed: () async {
                        await imagePicker(source: ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                    new MaterialButton(
                      child: Text("Camera"),
                      onPressed: () async {
                        await imagePicker(source: ImageSource.camera);
                        Navigator.pop(context);
                        Navigator.of(context).pop();
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: height / 3,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _image == null
                ? NetworkImage(widget.productModel.productImage)
                : FileImage(_image),
          ),
        ),
      ),
    );
  }

  Widget editProduct(context) {
    return ListView(
      children: [
        MyTextField(
          hitText: 'Product Name',
          controller: _productName,
          obscureText: false,
        ),
        MyTextField(
          hitText: 'Product Company',
          controller: _productCompany,
          obscureText: false,
        ),
        MyTextField(
          hitText: 'Product Model',
          controller: _productModel,
          obscureText: false,
        ),
        MyTextField(
          hitText: 'Product Price',
          controller: _productPrice,
          obscureText: false,
        ),
        usedNew(context),
        MyTextField(
          hitText: 'Product Address',
          controller: _productAddress,
          obscureText: false,
        ),
        MyTextField(
          hitText: 'Product Description',
          controller: _productDescription,
          obscureText: false,
        ),
        MyTextField(
          hitText: 'Phone Number',
          controller: _productPhoneNumber,
          obscureText: false,
        ),
        productImage(context),
        isLoading == false
            ? MyButton(
                name: 'Submint',
                onPressed: () {
                  checkValid(context);
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),
      ],
    );
  }

  void checkVeryfaction(context) async {
    setState(() {
      isLoading = true;
    });

    _image != null ? await _uploadFile(_image) : Container();

    var productValue = myProvider.updataProduct(
      pathImage:
          _image != null ? _imagePath : widget.productModel.productImagePath,
      productAddress: _productAddress.text,
      productCompany: _productCompany.text,
      productId: widget.productModel.productId,
      productDescription: _productDescription.text,
      productPhoneNumber: _productPhoneNumber.text,
      productModel: _productModel.text,
      productType: _productType,
      productPrice: _productPrice.text,
      productImage:
          _image == null ? widget.productModel.productImage : _imageUrl,
      productName: _productName.text,
    );
    if (productValue != null) {
      productValue.whenComplete(
        () => {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => HomeScreen(),
            ),
          ),
          setState(() {
            isLoading = false;
          }),
        },
      );
    }
  }

  @override
  build(BuildContext context) {
    myProvider = Provider.of<MyProvider>(context);
    myProvider.getProductData();
    list = myProvider.getProductList;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.productModel != null
              ? editProduct(context)
              : Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 20),
                  ),
                ),
        ),
      ),
    );
  }
}
