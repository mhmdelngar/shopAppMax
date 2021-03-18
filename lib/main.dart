import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/auth.dart';
import 'package:shop_app_state_manangement/scrrens/auth_screen.dart';
import 'package:shop_app_state_manangement/scrrens/edit_screen_page.dart';
import 'package:shop_app_state_manangement/scrrens/orders_screen.dart';
import 'package:shop_app_state_manangement/scrrens/splash_screen.dart';
import 'package:shop_app_state_manangement/scrrens/user_product_screen.dart';

import './provider/cart.dart';
import './provider/orders.dart';
import './provider/products.dart';
import './scrrens/cart_screen.dart';
import './scrrens/product_detail_screen.dart';
import 'scrrens/pdoduct-over-view-screen.dart';

void main() {
  runApp(Center(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.id,
            ),
            create: null,
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx, auth, previousProducts) => Order(
                auth.token,
                previousProducts == null ? [] : previousProducts.orders,
                auth.id),
            create: null,
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'shopApp',
            theme: ThemeData(
              primaryColor: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    future: auth.tryLogIn(),
                    builder: (ctx, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              // AuthScreen.nameOfTheScreen: (ctx) => AuthScreen(),
              ProductOverViewScreen.nameOfTheScreen: (ctx) =>
                  ProductOverViewScreen(),
              ProductDetailScreen.nameOfTheScreen: (ctx) =>
                  ProductDetailScreen(),
              CartScreen.nameOfTheScreen: (ctx) => CartScreen(),
              OrdersScreen.nameOfTheScreen: (ctx) => OrdersScreen(),
              UserProductScreen.nameOfTheScreen: (ctx) => UserProductScreen(),
              EditProductScreen.nameOfTheScreen: (ctx) => EditProductScreen()
            },
          ),
        ));
  }
}
