import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/orders.dart';

class OrderItems extends StatefulWidget {
  final OrderItem orderItem;

  const OrderItems({Key key, this.orderItem}) : super(key: key);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _expanded
          ? min(widget.orderItem.product.length * 20.0 + 110, 200)
          : 95,
      // constraints: BoxConstraints(
      // minHeight: _expanded ? 100 : 50, maxHeight: _expanded ? 300 : 200),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.orderItem.amount.toString(),
              ),
              subtitle: Text(
                DateFormat.yMd().format(widget.orderItem.date),
              ),
              trailing:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                margin: EdgeInsets.only(right: 15, left: 15),
                height: _expanded
                    ? min(widget.orderItem.product.length * 20.0 + 10, 180)
                    : 0,
                child: ListView(
                  children: widget.orderItem.product
                      .map((e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text('${e.quantity}x *${e.price}')
                            ],
                          ))
                      .toList(),
                ))
          ],
        ),
      ),
    );
  }
}
