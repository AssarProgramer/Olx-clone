import 'dart:io';
import 'dart:ui';
import 'package:clay_containers/clay_containers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wapar/config/colors.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/provider/profile_provider/profile_provider.dart';
import 'package:wapar/screens/home_screen.dart';
import 'package:wapar/widgets/costom_button.dart';
import 'package:wapar/widgets/costom_text_field.dart';
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
  UserModel currentUser;
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
          path.basename(_image.toString()),
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
      userName: currentUser.userFullName,
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
      setState(() {
        isLoading = false;
      });
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

  imagePicker({ImageSource source}) async {
    PickedFile imagePicked = await ImagePicker().getImage(
      source: source,
      imageQuality: 50,
    );
    setState(() {
      _image = File(imagePicked.path);
    });
  }

  Widget usedNew(context) {
    return GestureDetector(
      onTap: () {
        toggleProductType();
      },
      child: ClayContainer(
        borderRadius: 30,
        spread: 1,
        color: Theme.of(context).primaryColor,
        emboss: true,
        parentColor: Theme.of(context).primaryColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.only(left: 10, top: 15),
          height: height / 12,
          width: double.infinity,
          child: Text(
            _productType,
            style: TextStyle(fontSize: 16, color: textsColor),
          ),
        ),
      ),
    );
  }

  var alert;
  Widget productImage(context) {
    return ClayContainer(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      depth: 40,
      spread: 1,
      borderRadius: 10,
      child: Container(
        height: height / 3,
        width: double.infinity,
        child: _image == null
            ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
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
                icon: ClayContainer(
                  child: Icon(Icons.add_a_photo),
                  spread: 1,
                ),
                label: ClayText(
                  'Add Image',
                  color: textsColor,
                ),
              )
            : Image.file(
                _image,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget addProduct(context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDropDown(),
          CostomTextField(
            controller: _productName,
            passwordShot: false,
            hitText: 'Product Name',
          ),
          CostomTextField(
            hitText: 'Product Company',
            controller: _productCompany,
            passwordShot: false,
          ),
          CostomTextField(
            hitText: 'Product Model',
            controller: _productModel,
            passwordShot: false,
          ),
          CostomTextField(
            hitText: 'Product Price',
            controller: _productPrice,
            keybord: TextInputType.phone,
            passwordShot: false,
          ),
          usedNew(context),
          CostomTextField(
            hitText: 'Product Address',
            controller: _productAddress,
            passwordShot: false,
          ),
          CostomTextField(
            hitText: 'Product Description',
            controller: _productDescription,
            passwordShot: false,
          ),
          CostomTextField(
            hitText: 'Phone Number',
            keybord: TextInputType.phone,
            inputFormatter: [
              LengthLimitingTextInputFormatter(11),
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _productPhoneNumber,
            passwordShot: false,
          ),
          SizedBox(
            height: 10,
          ),
          productImage(context),
        ],
      ),
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
            child: ClayContainer(
              borderRadius: 30,
              spread: 1,
              color: Theme.of(context).primaryColor,
              emboss: true,
              // parentColor: Theme.of(context).primaryColor,
              child: Container(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).primaryColor,
                    filled: true,
                    contentPadding: EdgeInsets.only(top: 37, left: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  isExpanded: true,
                  value: _selectedLocation,
                  hint: Text(
                    'Select Category',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style:
                      TextStyle(color: textsColor, fontWeight: FontWeight.bold),
                  onChanged: (salutation) =>
                      setState(() => _selectedLocation = salutation),
                  validator: (value) =>
                      value == null ? "Please Select Category" : null,
                  items:
                      _locations.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    profileProvider.getProfileData();
    currentUser = profileProvider.getUserData;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: CostomButton(
          title: 'Submit',
          onTap: () {
            checkValid(context);
          },
        ),
      ),
      key: scaffoldKey,
      body: isLoading == false
          ? ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: addProduct(context),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
