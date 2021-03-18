import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const nameOfTheScreen = '/ProductDetailScreen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final loaddedProduct = Provider.of<Products>(context).findById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loaddedProduct.title),
              background: Container(
                width: double.infinity,
                child: Hero(
                  tag: loaddedProduct.id,
                  child: Image.network(
                    loaddedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$ ${loaddedProduct.price.toString()}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${loaddedProduct.description.toString()}',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 800,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
