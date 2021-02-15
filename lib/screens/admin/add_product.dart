import 'package:buy_it_app/models/product.dart';
import 'package:buy_it_app/services/store.dart';
import 'package:flutter/material.dart';
import 'package:buy_it_app/widgets/custem_textfield.dart';

// ignore: must_be_immutable
class AddProduct extends StatelessWidget {
  static const String id = 'add_product';

  final _store = Store();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _name, _price, _descreption, _category, _imageLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustemTextField(
              hint: 'Product Name',
              icon: null,
              onClick: (val) {
                _name = val;
              },
            ),
            SizedBox(height: 10),
            CustemTextField(
              hint: 'Product Price',
              icon: null,
              onClick: (val) {
                _price = val;
              },
            ),
            SizedBox(height: 10),
            CustemTextField(
              hint: 'Product Description',
              icon: null,
              onClick: (val) {
                _descreption = val;
              },
            ),
            SizedBox(height: 10),
            CustemTextField(
              hint: 'Product Category',
              icon: null,
              onClick: (val) {
                _category = val;
              },
            ),
            SizedBox(height: 10),
            CustemTextField(
              hint: 'Product Location',
              icon: null,
              onClick: (val) {
                _imageLocation = val;
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Add Product'),
              onPressed: () {
                if (_globalKey.currentState.validate()) {
                  _globalKey.currentState.save();
                  _store.addProduct(Product(
                    pName: _name,
                    pPrice: _price,
                    pDescription: _descreption,
                    pCategory: _category,
                    pLocation: _imageLocation,
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
