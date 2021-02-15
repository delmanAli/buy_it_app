import 'models/product.dart';

List<Product> getProductByCategory(String kJackets, List<Product> allProduct) {
  List<Product> products = [];
  try {
    for (var product in allProduct) {
      if (product.pCategory == kJackets) {
        products.add(product);
      }
    }
  } on Error catch (e) {
    print(e);
  }
  return products;
}
