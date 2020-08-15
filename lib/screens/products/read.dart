import 'package:adminapps/db/storage_service.dart';
import 'package:adminapps/models/products/product_crud.dart';
import 'package:adminapps/screens/details.dart';
import 'package:adminapps/screens/products/update.dart';
import 'package:flutter/material.dart';

import 'create.dart';

class ListProduct extends StatefulWidget {
    static const routeName = '/product-list';
    @override
    _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {

    ProductService _products = ProductService();
    List _items = [];
    FireStorageService _fireStorageService = FireStorageService();
    bool _loading = false;

    Future getAllProducts() async {

        setState(() => _loading = false);

        final data = await _products.fetchAndSetProducts();
        setState(() {
            _items = data;
            _loading = true;
        });
    }

    // LOAD IMAGE
    Future<Widget> _getImage(BuildContext context, String image) async {
        Image m;
        await _fireStorageService.loadImage(context, image).then((downloadUrl) {
            m = Image.network(
                downloadUrl.toString(),
                fit: BoxFit.cover,
            );
        });
        return m;
    }

    Future<void> _refresh() async {
        final reload = await _products.fetchAndSetProducts();
        return reload;
    }

    @override
    void initState() {
        super.initState();

        getAllProducts();
        
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'Listes des produits',
                    style: TextStyle(
                        color: Colors.white
                    ),),
                backgroundColor: Colors.purple,
                leading: IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white, 
                    onPressed: () => Navigator.of(context).pop()
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(
                            Icons.add,
                            color: Colors.white
                        ), 
                        onPressed: () => Navigator.pushNamed(context, AddProduct.routeName)
                    )
                ],
            ),

            body: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.purple,
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.12,
                    child: _loading == false ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),)) : ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, i) {
                            return InkWell(
                                onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return Details(_items[i].id, _items[i].titre, _items[i].categorie, _items[i].image[0], _items[i].description, _items[i].prix, _items[i].quantite);
                                    }));
                                },
                                child: Card(
                                    elevation: 0.5,
                                    margin: EdgeInsets.fromLTRB(0, 0.8, 0, 0.8),
                                    child: ListTile(
                                        leading: CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: Colors.transparent,
                                            child: FutureBuilder(
                                                future: _getImage(context, _items[i].image[0]),
                                                builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.done)
                                                        return Container(
                                                            height: 40,
                                                            width: 40,
                                                            child: snapshot.data,
                                                        );

                                                    return Container();
                                                },
                                            )
                                        ),
                                        title: Text(_items[i].titre),
                                        trailing: Container(
                                            width: 100,
                                            child: Row(
                                                children: <Widget>[
                                                    IconButton(
                                                        icon: Icon(
                                                            Icons.edit,
                                                            color: Colors.purple,
                                                        ), 
                                                        onPressed: () {
                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                                return UpdateProduct(_items[i].id, _items[i].titre, _items[i].categorie, _items[i].image[0], _items[i].image[1],_items[i].image[2], _items[i].description, _items[i].prix, _items[i].quantite);
                                                            }));
                                                        }
                                                    ),

                                                    IconButton(
                                                        icon: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                        ), 
                                                        onPressed: (() =>_products.deleteProduct(_items[i].id))
                                                    ),
                                                ],
                                            ),
                                        )
                                    ),
                                ),
                            );
                        },
                    ),  
                )
            ),
        
        );
    }
}