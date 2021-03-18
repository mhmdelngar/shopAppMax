import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/auth.dart';

import '../provider/cart.dart';
import '../provider/product.dart';
import '../scrrens/product_detail_screen.dart';

class ProductItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.nameOfTheScreen,
            arguments: product.id),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            title: Text(product.title),
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                color: Theme.of(context).accentColor,
                icon: product.isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () async {
                  try {
                    await product.favoriteChange(auth.token, auth.id);
                  } catch (error) {
                    print(error);
                  }
                },
              ),
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added to The cart !'),
                  // backgroundColor: Colors.grey,
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                    label: 'Undo',
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
