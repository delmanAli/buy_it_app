import 'package:buy_it_app/screens/user/product_info.dart';
import 'package:flutter/material.dart';
import 'package:buy_it_app/models/product.dart';

import '../functions.dart';

Widget productView(String pCategory, List<Product> allProduct) {
  List<Product> products;
  products = getProductByCategory(pCategory, allProduct);
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
}
