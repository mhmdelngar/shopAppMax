import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widgets/drawer.dart';
import '../widgets/shwoingProduct.dart';
import 'edit_screen_page.dart';

class UserProductScreen extends StatelessWidget {
  static const nameOfTheScreen = '/UserProductScreen';
  Future<void> onrefrech(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');

    return Scaffold(
        appBar: AppBar(
          title: Text('You products'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.nameOfTheScreen);
                })
          ],
        ),
        drawer: TheMainDrawer(),
        body: FutureBuilder(
          future: onrefrech(context),
          builder: (ctx, snapShot) =>
              snapShot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        return onrefrech(context);
                      },
                      child: Consumer<Products>(
                        builder: (ctx, myProducts, _) => ListView.builder(
                          itemCount: myProducts.items.length,
                          itemBuilder: (ctx, index) {
                            return ShowingProduct(
                              title: myProducts.items[index].title,
                              imageUrl: myProducts.items[index].imageUrl,
                              description: myProducts.items[index].description,
                              id: myProducts.items[index].id,
                              price: myProducts.items[index].price,
                            );
                          },
                        ),
                      )),
        ));
  }
}
