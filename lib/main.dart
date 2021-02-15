import 'package:buy_it_app/constants.dart';
import 'package:buy_it_app/provider/admin_mode.dart';
import 'package:buy_it_app/provider/cart_item.dart';
import 'package:buy_it_app/provider/modal_hud.dart';
import 'package:buy_it_app/screens/admin/add_product.dart';
import 'package:buy_it_app/screens/admin/admin_home.dart';
import 'package:buy_it_app/screens/admin/edit_product.dart';
import 'package:buy_it_app/screens/admin/manage_product.dart';
import 'package:buy_it_app/screens/admin/order_detail.dart';
import 'package:buy_it_app/screens/admin/order_screen.dart';
import 'package:buy_it_app/screens/login_screen.dart';
import 'package:buy_it_app/screens/signup_screen.dart';
import 'package:buy_it_app/screens/user/cart_screen.dart';
import 'package:buy_it_app/screens/user/home_page.dart';
import 'package:buy_it_app/screens/user/product_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          );
        } else {
          isUserLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModalHud>(
                create: (context) => ModalHud(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'BUY IT',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: isUserLoggedIn ? HomePage.id : LoginScreen.id,
              // initialRoute: HomePage.id,
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                HomePage.id: (context) => HomePage(),
                AdminHome.id: (context) => AdminHome(),
                AddProduct.id: (context) => AddProduct(),
                ManageProduct.id: (context) => ManageProduct(),
                EditProduct.id: (context) => EditProduct(),
                ProductInfo.id: (context) => ProductInfo(),
                CartScreen.id: (context) => CartScreen(),
                OrderScreen.id: (context) => OrderScreen(),
                OrderDetail.id: (context) => OrderDetail(),
              },
            ),
          );
        }
      },
    );
  }
}
