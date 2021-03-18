import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';
import 'product-items.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;

  const ProductGrid({Key key, this.showFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    List<Product> productItems =
        showFavorite ? products.favoriteItems : products.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: productItems[index],
        child: ProductItems(),
      ),
      itemCount: productItems.length,
    );
  }
}
