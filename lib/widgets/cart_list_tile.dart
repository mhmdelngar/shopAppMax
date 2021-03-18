import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/cart.dart';

class CartListTile extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartListTile(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity,
      @required this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.only(right: 10, top: 6, bottom: 5),
      ),
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Are you sure ?'),
                content: Text('Do you want to dismiss this order?'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  )
                ],
              )),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  '\$ ${price.toStringAsFixed(1)}',
                ),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text(
            'total amount \$${price * quantity}',
          ),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
