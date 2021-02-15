import 'package:buy_it_app/constants.dart';
import 'package:buy_it_app/models/product.dart';
import 'package:buy_it_app/services/store.dart';
import 'package:buy_it_app/widgets/custem_textfield.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditProduct extends StatelessWidget {
  static const String id = 'edit_product';

  final _store = Store();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _name, _price, _descreption, _category, _imageLocation;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
            ),
            Column(
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
                      _store.editProduct(
                        {
                          kProductName: _name,
                          kProductPrice: _price,
                          kProductDescription: _descreption,
                          kProductCategory: _category,
                          kProductLocation: _imageLocation,
                        },
                        product.pId,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
