import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wapar/auths/sign_in.dart';
import 'package:wapar/auths/sign_up.dart';
import 'package:wapar/provider/auth_provider/auth_provider.dart';
import 'package:wapar/provider/categories_provider/categories_provider.dart';
import 'package:wapar/provider/product_provider/my_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wapar/provider/profile_provider/profile_provider.dart';
import 'package:wapar/screens/home_screen.dart';

const bool debugEnableDeviceSimulator = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyProvider>(
          create: (context) => MyProvider(),
        ),
        ChangeNotifierProvider<AuthProdiver>(
          create: (context) => AuthProdiver(),
        ),
        ChangeNotifierProvider<CategoriesProvider>(
          create: (context) => CategoriesProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        )
      ],
      child: Consumer(builder: (context, MyProvider myModel, child) {
        return MaterialApp(
          theme: MyProvider.light,
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return HomeScreen();
              }
              return SignIn();
            },
            stream: FirebaseAuth.instance.authStateChanges(),
          ),
        );
      }),
    );
  }
}
