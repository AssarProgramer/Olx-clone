import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:wapar/drawer_side/admin/admin_screen.dart';
import 'package:wapar/drawer_side/profile_screen.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/provider/categories_provider/categories_provider.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/provider/profile_provider/profile_provider.dart';
import 'package:wapar/screens/about.dart';
import 'package:wapar/screens/categorys_screen.dart';
import 'package:wapar/screens/contact_us_screen.dart.dart';
import 'package:wapar/screens/detile_screen.dart';
import 'package:wapar/auths/login_screen.dart';
import 'package:wapar/screens/product_Search.dart';
import 'package:wapar/widgets/singal_product.dart';

enum category {
  mobile,
  motorCycle,
  latop,
  car,
  tv,
  animal,
  other,
  shoes,
}

class HomeScreen extends StatefulWidget {
  var isMode;
  HomeScreen({this.isMode});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MyProvider myProvider;
  CategoriesProvider myCategorys;
  double height;
  double width;
  Size size;
  Widget userAccountsDrawerHeader(context, currentUser) {
    return Container(
      height: height / 3.5,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: DrawerHeader(
        child: UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              currentUser.userImage,
            ),
          ),
          accountName: Text(
            currentUser.userFullName,
          ),
          accountEmail: Text(currentUser.userEmail),
        ),
      ),
    );
  }

  Widget listTile({String name, IconData iconData, Function onTap, context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            iconData,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            name,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget callingListTile(context, {UserModel currentUser}) {
    return Column(
      children: [
        listTile(
          iconData: Icons.home,
          name: 'Home',
          context: context,
        ),
        listTile(
            iconData: Icons.add,
            name: 'Admin',
            context: context,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AdminScreen(null, 0, currentUser: currentUser),
                ),
              );
            }),
        listTile(
            iconData: Icons.person,
            name: 'Account',
            context: context,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    currentUser: currentUser,
                  ),
                ),
              );
            }),
        listTile(
            iconData: Icons.info,
            name: 'About',
            context: context,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => About(),
                ),
              );
            }),
        listTile(
          iconData: Icons.call,
          name: 'Contact',
          context: context,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ContactUsScreen(),
              ),
            );
          },
        ),
        listTile(
            iconData: Icons.exit_to_app,
            name: 'Logout',
            context: context,
            onTap: () async {
              // await FirebaseAuth.instance.signOut().then(
              //   (value) => Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //       builder: (context) => LoginScreen(),
              //     ),
              //   ),
              // );
              await FirebaseAuth.instance.signOut().whenComplete(
                    () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ),
                  );
            }),
        Consumer<MyProvider>(
          builder: (context, notifier, child) => SwitchListTile(
            title: notifier.darkTheme == false
                ? Text("Dark Mode")
                : Text("Light Mode"),
            onChanged: (val) {
              notifier.toggleTheme();
            },
            value: notifier.darkTheme,
          ),
        ),
      ],
    );
  }

  Widget singalCategory(
      {String categoryName,
      String name,
      Color color,
      IconData iconData,
      bool value,
      Color iconColor}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          myCategorys.getCategoryData(category: categoryName);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CategoryScreen(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              value
                  ? Center(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: color,
                        child: Image.asset('images/shoes.png'),
                      ),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: color,
                      child: Icon(iconData, color: iconColor)),
              SizedBox(
                height: 5,
              ),
              Text(
                name,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget allSingalcategory(context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              singalCategory(
                categoryName: "MOBILE",
                color: Color(0xff5ef2fc),
                iconData: Icons.phone_android,
                iconColor: Theme.of(context).accentColor,
                name: 'Mobile',
                value: false,
              ),
              singalCategory(
                color: Color(0xfff4b07f),
                categoryName: "MOTOR-CYCLE",
                iconData: Icons.motorcycle,
                iconColor: Theme.of(context).accentColor,
                name: 'Motorcycle',
                value: false,
              ),
              singalCategory(
                color: Color(0xffd284f2),
                iconData: Icons.pets,
                iconColor: Theme.of(context).accentColor,
                name: 'Animals',
                categoryName: "ANIMALS",
                value: false,
              ),
              singalCategory(
                color: Color(0xff55f39f),
                iconData: Icons.laptop_windows,
                iconColor: Theme.of(context).accentColor,
                name: 'Laptop',
                categoryName: "LAPTOP",
                value: false,
              ),
            ],
          ),
          Row(
            children: [
              singalCategory(
                color: Colors.red,
                iconData: Icons.tv,
                iconColor: Theme.of(context).accentColor,
                name: 'Tv',
                categoryName: "Tv",
                value: false,
              ),
              singalCategory(
                color: Color(0xff77bffa),
                iconColor: Theme.of(context).accentColor,
                name: 'Shoes',
                categoryName: "SHOES",
                value: true,
              ),
              singalCategory(
                color: Colors.red,
                iconData: Icons.time_to_leave,
                iconColor: Theme.of(context).accentColor,
                name: 'Car',
                categoryName: "CAR",
                value: false,
              ),
              singalCategory(
                color: Colors.blue,
                iconData: Icons.pending,
                iconColor: Theme.of(context).accentColor,
                name: 'Other',
                categoryName: "OTHER",
                value: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getProfileData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    myProvider = Provider.of<MyProvider>(context);
    myProvider.getProductData();
    myCategorys = Provider.of<CategoriesProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);

    List<ProductModel> productList = myProvider.getProductList;
    UserModel currentUser = profileProvider.getUserData;
    String formatted;
    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: [
              userAccountsDrawerHeader(context, currentUser),
              SizedBox(
                height: 5,
              ),
              callingListTile(context, currentUser: currentUser),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearch(
                  hintText: 'Type Product Name',
                  formatted: formatted,
                ),
              );
            },
          ),
        ],
        centerTitle: true,
        title: Text('Wapar'),
      ),
      body: productList.isNotEmpty
          ? ListView(
              children: [
                allSingalcategory(context),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    Timestamp timeStamp = productList[index].productTime;
                    var nowTime = timeStamp.millisecondsSinceEpoch;
                    formatted = formatTime(nowTime);
                    return SingalProduct(
                      singalProductImage: productList[index].productImage,
                      singalProductName: productList[index].productName,
                      singalProductPrice: productList[index].productPrice,
                      singalProductType: productList[index].productType,
                      singalProductTime: formatted,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetileScreen(
                              productTime: formatted,
                              productAddress: productList[index].productAddress,
                              productCompany: productList[index].productCompany,
                              productDescription:
                                  productList[index].productDescription,
                              productModel: productList[index].productModel,
                              productName: productList[index].productName,
                              productPhoneNumber:
                                  productList[index].productPhoneNumber,
                              productPrice: productList[index].productPrice,
                              productType: productList[index].productType,
                              productImage: productList[index].productImage,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
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
