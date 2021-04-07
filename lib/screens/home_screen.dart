import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:wapar/auths/sign_in.dart';
import 'package:wapar/post/admin_screen.dart';
import 'package:wapar/profile/profile_screen.dart';
import 'package:wapar/model/product_model.dart';
import 'package:wapar/model/user_,model.dart';
import 'package:wapar/profile/widgets/profile_edit.dart';
import 'package:wapar/provider/categories_provider/categories_provider.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:wapar/provider/profile_provider/profile_provider.dart';
import 'package:wapar/screens/about.dart';
import 'package:wapar/screens/categorys_screen.dart';
import 'package:wapar/screens/contact_us_screen.dart.dart';
import 'package:wapar/screens/detile_screen.dart';
import 'package:wapar/screens/product_Search.dart';
import 'package:wapar/widgets/singal_product.dart';
import 'package:intl/intl.dart';

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
  String formatted;

  Widget userAccountsDrawerHeader(context, currentUser) {
    return ClayContainer(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      depth: 40,
      spread: 1,
      child: Container(
        height: height / 3.5,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: DrawerHeader(
          child: UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  currentUser.userImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadding) {
                    return loadding == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ),
            accountName: Text(
              currentUser.userFullName,
            ),
            accountEmail: Text(currentUser.userEmail),
          ),
        ),
      ),
    );
  }

  Widget listTile({String name, IconData iconData, Function onTap, context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClayContainer(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        depth: 40,
        spread: 1,
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
            name: 'Post',
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
                        builder: (context) => SignIn(),
                      ),
                    ),
                  );
            }),
        // Consumer<MyProvider>(
        //   builder: (context, notifier, child) => SwitchListTile(
        //     title: notifier.darkTheme == false
        //         ? Text("Dark Mode")
        //         : Text("Light Mode"),
        //     onChanged: (val) {
        //       notifier.toggleTheme();
        //     },
        //     value: notifier.darkTheme,
        //   ),
        // ),
      ],
    );
  }

  Widget singalCategory(
      {String categoryName,
      String name,
      IconData iconData,
      bool value,
      Color iconColor}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          myCategorys.getCategoryData(category: categoryName);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CategoryScreen(formatted: formatted),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ClayContainer(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            depth: 40,
            spread: 10,
            borderRadius: 10,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  value
                      ? Center(
                          child: ClayContainer(
                            borderRadius: 20,
                            spread: 2,
                            color: Theme.of(context).primaryColor,
                            emboss: true,
                            parentColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Image.asset(
                                'images/shoes.png',
                                color: Colors.black,
                                height: 25,
                              ),
                            ),
                          ),
                        )
                      : ClayContainer(
                          borderRadius: 20,
                          spread: 1,
                          color: Theme.of(context).primaryColor,
                          emboss: true,
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(iconData, color: Colors.black)),
                        ),
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
                iconData: Icons.phone_android,
                name: 'Mobile',
                value: false,
              ),
              singalCategory(
                categoryName: "MOTOR-CYCLE",
                iconData: Icons.motorcycle,
                name: 'Motorcycle',
                value: false,
              ),
              singalCategory(
                iconData: Icons.pets,
                name: 'Animals',
                categoryName: "ANIMALS",
                value: false,
              ),
              singalCategory(
                iconData: Icons.laptop_windows,
                name: 'Laptop',
                categoryName: "LAPTOP",
                value: false,
              ),
            ],
          ),
          Row(
            children: [
              singalCategory(
                iconData: Icons.tv,
                name: 'Tv',
                categoryName: "Tv",
                value: false,
              ),
              singalCategory(
                name: 'Shoes',
                categoryName: "SHOES",
                value: true,
              ),
              singalCategory(
                iconData: Icons.time_to_leave,
                name: 'Car',
                categoryName: "CAR",
                value: false,
              ),
              singalCategory(
                iconData: Icons.pending,
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
    UserModel currentUser = profileProvider.getUserData;
    List<ProductModel> productList = myProvider.getProductList;

    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
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
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.74,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    formatted = DateFormat.yMMMd().format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(productList[index].productTime),
                      ),
                    );
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
                              userName: productList[index].userName,
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
              child: CircularProgressIndicator(),
            ),
    );
  }
}
