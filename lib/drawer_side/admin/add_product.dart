import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/screens/home_screen.dart';
import 'package:wapar/widgets/my_button.dart';
import 'package:wapar/widgets/my_text_field.dart';
import 'package:path/path.dart' as path;

class AddProductScreen extends StatefulWidget {
  final UserModel currentUser;
  AddProductScreen({this.currentUser});
  static Pattern phoneNumberPattern =
      r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';
  static Pattern pricePattern = r"^[0-9]+$";

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  RegExp phoneRegix = new RegExp(AddProductScreen.phoneNumberPattern);
  RegExp priceRegix = new RegExp(AddProductScreen.pricePattern);
  String _productType = 'USED';
  bool isLoading = false;
  TextEditingController _productName = TextEditingController();

  TextEditingController _productDescription = TextEditingController();

  TextEditingController _productPrice = TextEditingController();

  TextEditingController _productAddress = TextEditingController();

  TextEditingController _productCompany = TextEditingController();

  TextEditingController _productModel = TextEditingController();

  TextEditingController _productPhoneNumber = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double height;
  double width;
  Size size;

  File _image;

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
    bool productImage = _image == null;
    bool selectedCategory = _selectedLocation == null;
    if (productName &&
        productDescription &&
        productPrice &&
        productAddress &&
        productModel &&
        productPhoneNumber &&
        productCompany &&
        productImage &&
        selectedCategory) {
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

    if (productCompany) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Product Company is Empty"),
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
    }
    if (productImage) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("product Image is Empty"),
        ),
      );
      return;
    } else {
      checkVeryfaction(context);
    }
  }

  void checkVeryfaction(context) async {
    setState(() {
      isLoading = true;
    });
    MyProvider myProvider = Provider.of<MyProvider>(context, listen: false);

    final ref = FirebaseStorage.instance.ref().child('product_image').child(
          path.basename(_image.toString()) + '.jpg',
        );
    await ref.putFile(_image);
    String pathImage = path.basename(_image.toString());

    final _productImage = await ref.getDownloadURL();
    var value = myProvider.addProduct(
      productCategory: _selectedLocation,
      pathImage: pathImage,
      productAddress: _productAddress.text,
      productCompany: _productCompany.text,
      productDescription: _productDescription.text,
      productPhoneNumber: _productPhoneNumber.text,
      productModel: _productModel.text,
      productType: _productType,
      productPrice: _productPrice.text,
      productImage: _productImage ?? '',
      productName: _productName.text,
    );

    if (value != null) {
      value.whenComplete(
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
    } else {
      Container();
    }

    //ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: Theme.of(context).errorColor,
    //     content: value == null
    //         ? Container()
    //         : Text(
    //             value.toString(),
    //           ),
    //   ),
    // );
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
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.only(left: 10, top: 15),
        margin: EdgeInsets.symmetric(vertical: 7),
        height: height / 12,
        width: double.infinity,
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
          color: Colors.red,
          gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor,
          ]),
        ),
        child: _image == null
            ? Icon(
                Icons.image,
                size: 150,
              )
            : Image.file(
                _image,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget addProduct(context) {
    return ListView(
      children: [
        _buildDropDown(),
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
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
          ],
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
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

  List<String> _locations = [
    'MOBILE',
    'MOTOR-CYCLE',
    'LAPTOP',
    'SHOES',
    'OTHER',
    'ANIMALS',
    'CAR',
    'TV',
  ];

  String _selectedLocation;

  Widget _buildDropDown() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 37, left: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                isExpanded: true,
                value: _selectedLocation,
                hint: Text(
                  'Select Category',
                ),
                onChanged: (salutation) =>
                    setState(() => _selectedLocation = salutation),
                validator: (value) =>
                    value == null ? "Please Select Category" : null,
                items: _locations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: addProduct(context),
        ),
      ),
    );
  }
}
