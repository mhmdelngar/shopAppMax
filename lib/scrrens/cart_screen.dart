import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/orders.dart';
import 'package:shop_app_state_manangement/widgets/cart_list_tile.dart';

import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  static const nameOfTheScreen = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('You Cart'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total amount',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(1)} \$',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.getlength,
              itemBuilder: (context, i) {
                return CartListTile(
                  title: cart.items.values.toList()[i].title,
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  quantity: cart.items.values.toList()[i].quantity,
                  price: cart.items.values.toList()[i].price,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isloaded = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: isloaded
            ? CircularProgressIndicator()
            : Text(
                'Order now',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
        onPressed: (widget.cart.totalAmount <= 0 || isloaded)
            ? null
            : () async {
                setState(() {
                  isloaded = true;
                });
                await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.totalAmount,
                  DateTime.now(),
                  widget.cart.items.values.toList(),
                );
                setState(() {
                  isloaded = false;
                });
                widget.cart.clearItems();
              });
  }
}
