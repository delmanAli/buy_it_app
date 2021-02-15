import 'package:buy_it_app/constants.dart';
import 'package:buy_it_app/screens/admin/add_product.dart';
import 'package:buy_it_app/screens/admin/manage_product.dart';
import 'package:buy_it_app/screens/admin/order_screen.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  static const String id = 'admin_home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProduct.id);
            },
            child: Text('Add Product'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ManageProduct.id);
            },
            child: Text('Edit Product'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, OrderScreen.id);
            },
            child: Text('View Orders'),
          ),
        ],
      ),
    );
  }
}
