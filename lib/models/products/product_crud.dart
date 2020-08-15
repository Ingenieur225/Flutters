import 'package:adminapps/models/products/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {

    List<Product> _items = [];
    
    fetchAndSetProducts() async {
        const url = 'https://adminapps-acefe.firebaseio.com/products.json';
        try {
            final response = await http.get(url);
            final extractedData = json.decode(response.body) as Map<String, dynamic>;
            final List<Product> loadedProducts = [];
            extractedData.forEach((prodId, prodData) {
                loadedProducts.insert(0, Product(
                    id: prodId,
                    titre: prodData['titre'],
                    prix: prodData['prix'],
                    quantite: prodData['quantite'],
                    image: prodData['image'],
                    description: prodData['description'],
                    categorie: prodData['categorie'],
                ));
            });
            _items = loadedProducts;
            return _items;
        }
        catch (error) {
            print(error);
        }
    }

    Future<void> addProduct(Product product) async {
        const url = 'https://adminapps-acefe.firebaseio.com/products.json';
        try {
            final response = await http.post(url, body: json.encode(
                {
                    'titre': product.titre,
                    'prix': product.prix,
                    'quantite': product.quantite,
                    'image': product.image,
                    'description': product.description,
                    'categorie': product.categorie
                }),
            );
            final newProduct = Product(
                id: json.decode(response.body)['name']
            );
            _items.add(newProduct);
            
        } 
        catch (error) {
            print(error);
        }
    }

    Future<void> updateProduct(String id, Product newProduct) async {;

        final prodIndex = _items.indexWhere((prod) => prod.id == id);
        if (prodIndex <= 0) {
            final url = 'https://adminapps-acefe.firebaseio.com/products/$id.json';
            await http.patch(url,
                body: json.encode({
                    'titre': newProduct.titre,
                    'prix': newProduct.prix,
                    'quantite': newProduct.quantite,
                    'image': newProduct.image,
                    'description': newProduct.description,
                    'categorie': newProduct.categorie
                }));
            _items[prodIndex] = newProduct;
        } 
        else {
            print('...');
        }
    }

    Future<void> deleteProduct(String id) async {
        final url = 'https://adminapps-acefe.firebaseio.com/products/$id.json';
        final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
        var existingProduct = _items[existingProductIndex];
        _items.removeAt(existingProductIndex);
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
            _items.insert(existingProductIndex, existingProduct);
            Fluttertoast.showToast(
                msg: 'Impossible de supprimer le produit',
                textColor: Colors.white,
                backgroundColor: Colors.black
            );
        }
        existingProduct = null;
    }
}