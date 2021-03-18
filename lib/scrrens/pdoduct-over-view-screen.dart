import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/products.dart';
import 'package:shop_app_state_manangement/widgets/drawer.dart';

import '../provider/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'cart_screen.dart';

enum Filter { favorite, all }

class ProductOverViewScreen extends StatefulWidget {
  static const nameOfTheScreen = '/ProductOverViewScreen';

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool showFav = false;
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero)
        .then((value) =>
            Provider.of<Products>(context, listen: false).fetchAndSetProduct())
        .then((value) {
      setState(() {
        isLoading = false;
      });
    }); //you can also do that in did change depndecies and make a boolean to stop fetching data because did change depndecies runs multiple times
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShopApp'),
        actions: [
          PopupMenuButton(
            onSelected: (Filter selectedValue) {
              setState(() {
                if (selectedValue == Filter.favorite) {
                  showFav = true;
                }
                if (selectedValue == Filter.all) {
                  showFav = false;
                }
              });
            },
            child: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('show favorite'),
                value: Filter.favorite,
              ),
              PopupMenuItem(
                child: Text('show all'),
                value: Filter.all,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.nameOfTheScreen);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cart.getlength.toString(),
            ),
          )
        ],
      ),
      drawer: TheMainDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(
              showFavorite: showFav,
            ),
    );
  }
}
