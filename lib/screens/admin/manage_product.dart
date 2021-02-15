import 'package:buy_it_app/constants.dart';
import 'package:buy_it_app/models/product.dart';
import 'package:buy_it_app/screens/admin/edit_product.dart';
import 'package:buy_it_app/services/store.dart';
import 'package:buy_it_app/widgets/custom_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageProduct extends StatefulWidget {
  static const String id = 'Manage_product';

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: StreamBuilder<QuerySnapshot>(
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
                      onTapUp: (details) {
                        double dx = details.globalPosition.dx;
                        double dy = details.globalPosition.dy;
                        double dx2 = MediaQuery.of(context).size.width - dx;
                        double dy2 = MediaQuery.of(context).size.width - dy;
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            dx,
                            dy,
                            dx2,
                            dy2,
                          ),
                          items: [
                            MyPopupMenuItem(
                              child: Text('Edit'),
                              onClick: () {
                                Navigator.pushNamed(
                                  context,
                                  EditProduct.id,
                                  arguments: products[index],
                                );
                              },
                            ),
                            MyPopupMenuItem(
                              child: Text('Delete'),
                              onClick: () {
                                _store.deleteProduct(products[index].pId);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
          }),
    );
  }
}
