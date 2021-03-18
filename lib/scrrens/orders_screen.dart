import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/orders.dart';
import 'package:shop_app_state_manangement/widgets/OrderItem.dart';

class OrdersScreen extends StatefulWidget {
  static const nameOfTheScreen = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future orderss;
  // ignore: missing_return
  Future oreddo() {
    orderss = Provider.of<Order>(context, listen: false).fetchData();
  }

  @override
  void initState() {
    oreddo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('entered');
    return Scaffold(
        appBar: AppBar(
          title: Text('Your orders'),
        ),
        body: FutureBuilder(
          future: orderss,
          builder: (ctx, orderData) {
            if (orderData.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (orderData.error != null) {
              return Center(
                child: Text('Ther is an error'),
              );
            } else {
              return Consumer<Order>(builder: (_, orderDate, child) {
                return Card(
                  child: ListView.builder(
                    itemBuilder: (context, index) => OrderItems(
                      orderItem: orderDate.orders[index],
                    ),
                    itemCount: orderDate.orders.length,
                  ),
                );
              });
            }
          },
        ));
  }
}
