import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/auth.dart';
import 'package:shop_app_state_manangement/scrrens/orders_screen.dart';
import 'package:shop_app_state_manangement/scrrens/pdoduct-over-view-screen.dart';
import 'package:shop_app_state_manangement/scrrens/user_product_screen.dart';

class TheMainDrawer extends StatelessWidget {
  const TheMainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Shop App',
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.center,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductOverViewScreen.nameOfTheScreen);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.nameOfTheScreen);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.apps),
            title: Text('Manage products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.nameOfTheScreen);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log out'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
