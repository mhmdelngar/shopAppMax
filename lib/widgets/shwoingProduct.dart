import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/products.dart';

import '../scrrens/edit_screen_page.dart';

class ShowingProduct extends StatelessWidget {
  final String id;
  final double price;
  final String imageUrl;
  final String title;
  final String description;

  ShowingProduct(
      {this.id, this.price, this.imageUrl, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      title: Text(title),
      subtitle: Text(price.toString()),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(EditProductScreen.nameOfTheScreen, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removeItems(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text('couldn\'t delete'),
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
