import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_state_manangement/provider/product.dart';
import 'package:shop_app_state_manangement/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const nameOfTheScreen = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageNode = FocusNode();
  var _form = GlobalKey<FormState>();
  Product editingProduct = Product(
    id: null,
    price: 0.0,
    title: '',
    description: '',
    imageUrl: '',
  );

  TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    // focusNode.addListener(() {});
    _imageNode.addListener(() => add());

    super.initState();
  }

  bool loaded = false;
  bool isFinished = false;
  var latestdata = {'title': '', 'price': '', 'description': ''};

  @override
  void didChangeDependencies() {
    if (!loaded) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        editingProduct = Provider.of<Products>(context).findById(productId);
        latestdata = {
          'title': editingProduct.title,
          'price': editingProduct.price.toString(),
          'description': editingProduct.description
        };
        _imageUrlController.text = editingProduct.imageUrl;
        loaded = true;
      }
    }

    super.didChangeDependencies();
  }

  void add() {
    print('v');
    if (!_imageNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> saveData() async {
    final validation = _form.currentState.validate();
    if (!validation) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isFinished = true;
    });
    if (editingProduct.id != null) {
      print(editingProduct.id);
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editingProduct.id, editingProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editingProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('there is an error'),
                  content: Text('something  is wrong'),
                  actions: [
                    FlatButton(
                      child: Text('okey'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    }
    setState(() {
      isFinished = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _descriptionNode.dispose();
    _priceNode.dispose();
    _imageUrlController.dispose();
    _imageNode.removeListener(add);
    _imageNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _imageNode.addListener(() => add);
    return Scaffold(
      appBar: AppBar(
        title: Text('You products'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveData();
              })
        ],
      ),
      // drawer: TheMainDrawer(),
      body: isFinished
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: latestdata['title'],
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).requestFocus(_priceNode),
                        onSaved: (value) {
                          editingProduct = Product(
                            title: value,
                            description: editingProduct.description,
                            id: editingProduct.id,
                            isFavorite: editingProduct.isFavorite,
                            imageUrl: editingProduct.imageUrl,
                            price: editingProduct.price,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: latestdata['price'].toString(),
                        focusNode: _priceNode,
                        decoration: InputDecoration(labelText: 'price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          // FocusScope.of(context).requestFocus(_descriptionNode)),
                          _descriptionNode.requestFocus();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter a price';
                          }

                          if (double.tryParse(value) == null) {
                            return 'please enter a price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter a price bigger than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editingProduct = Product(
                            title: editingProduct.title,
                            description: editingProduct.description,
                            id: editingProduct.id,
                            isFavorite: editingProduct.isFavorite,
                            imageUrl: editingProduct.imageUrl,
                            price: double.parse(value),
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: latestdata['description'],
                        focusNode: _descriptionNode,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          _imageNode.requestFocus();
                        },
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          editingProduct = Product(
                            title: editingProduct.title,
                            description: value,
                            id: editingProduct.id,
                            isFavorite: editingProduct.isFavorite,
                            imageUrl: editingProduct.imageUrl,
                            price: editingProduct.price,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter a description';
                          }

                          if (value.length < 10) {
                            return 'must be more than 10';
                          }

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Card(
                            child: Container(
                              child: _imageUrlController.text.isEmpty
                                  ? Text('add url')
                                  : Image.network(_imageUrlController.text),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _imageNode,
                              controller: _imageUrlController,
                              // focusNode: _descriptionNode,
                              decoration:
                                  InputDecoration(labelText: 'image url'),
                              keyboardType: TextInputType.url,
                              onFieldSubmitted: (value) {
                                saveData();
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onSaved: (value) {
                                editingProduct = Product(
                                  title: editingProduct.title,
                                  description: editingProduct.description,
                                  id: editingProduct.id,
                                  isFavorite: editingProduct.isFavorite,
                                  imageUrl: value,
                                  price: editingProduct.price,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter a url';
                                }

                                if (!value.startsWith('https') &&
                                    !value.startsWith('https')) {
                                  return 'please enter a valid url';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('jpeg') &&
                                    !value.endsWith('.png')) {
                                  return 'please enter a valid url photo';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
