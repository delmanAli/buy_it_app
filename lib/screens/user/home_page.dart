import 'package:buy_it_app/constants.dart';
import 'package:buy_it_app/models/product.dart';
import 'package:buy_it_app/screens/login_screen.dart';
import 'package:buy_it_app/screens/user/product_info.dart';
import 'package:buy_it_app/services/auth.dart';
import 'package:buy_it_app/services/store.dart';
import 'package:buy_it_app/widgets/product_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = Auth();
  final _store = Store();
  User loggedUser;
  int _tabBarIndex = 0;
  int _buttomBarIndex = 0;
  List<Product> _products;

  getCurrenUser() {
    loggedUser = _auth.getUser();
  }

  @override
  void initState() {
    super.initState();
    // _auth.getUser();
    getCurrenUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              fixedColor: kMainColor,
              currentIndex: _buttomBarIndex,
              onTap: (val) async {
                if (val == 2) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.clear();
                  await _auth.signOut();
                  Navigator.popAndPushNamed(
                    context,
                    LoginScreen.id,
                  );
                }
                setState(() {
                  _buttomBarIndex = val;
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: 'test',
                  icon: Icon(Icons.person),
                ),
                BottomNavigationBarItem(
                  label: 'test',
                  icon: Icon(Icons.account_balance_wallet_sharp),
                ),
                BottomNavigationBarItem(
                  label: 'Sign Out',
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: [
                  Text(
                    'jackets',
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 0 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Trouser',
                    style: TextStyle(
                      color: _tabBarIndex == 1 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 1 ? 16 : null,
                    ),
                  ),
                  Text(
                    'T-shirts',
                    style: TextStyle(
                      color: _tabBarIndex == 2 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 2 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Shoes',
                    style: TextStyle(
                      color: _tabBarIndex == 3 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                jacketView(),
                productView(kTrousers, _products),
                productView(kShoes, _products),
                productView(kTshirts, _products),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              // color: Colors.black,
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'descover'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.shopping_cart),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget jacketView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProducts(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          List<Product> products = [];
          for (var doc in snapshots.data.docs) {
            var data = doc.data();
            products.add(Product(
              pId: doc.id,
              pName: data[kProductName],
              pPrice: data[kProductPrice],
              pCategory: data[kProductCategory],
              pDescription: data[kProductDescription],
              pLocation: data[kProductLocation],
            ));
          }

          _products = [...products];
          products.clear();
          products = getProductByCategory(kJackets, _products);

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(ProductInfo.id, arguments: products[index]);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(products[index].pLocation),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          child: Opacity(
                            opacity: .6,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(products[index].pName),
                                    Text('\$ ${products[index].pPrice}'),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
            itemCount: products.length,
          );
        } else {
          return Center(
              child: Text(
            'Loading Please Wait...',
            textAlign: TextAlign.center,
          ));
        }
      },
    );
  }
}
