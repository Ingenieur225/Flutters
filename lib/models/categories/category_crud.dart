import 'package:adminapps/models/categories/category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategorieService {

    List<Category> _items = [];

    fetchAndSetCategorie() async {
        const url = 'https://adminapps-acefe.firebaseio.com/categories.json';
        try {
            final response = await http.get(url);
            final extractedData = json.decode(response.body) as Map<String, dynamic>;
            final List<Category> loadedCategory = [];
            extractedData.forEach((catId, catData) {
                loadedCategory.insert(0, Category(
                    id: catId,
                    image: catData['image'],
                    categorie: catData['categorie'],
                ));
            });
            _items = loadedCategory;
            return _items;
        }
        catch (error) {
            print(error);
        }
    }

    Future<void> addCategorie(Category category) async {
        const url = 'https://adminapps-acefe.firebaseio.com/categories.json';
        try {
            final response = await http.post(url, body: json.encode(
                {
                    'image': category.image,
                    'categorie': category.categorie
                }),
            );
            final newCategory = Category(
                id: json.decode(response.body)['name']
            );
            _items.add(newCategory);
            
        } 
        catch (error) {
            print(error);
        }
    }

    Future<void> updateCategoriet(String id, Category newCategory) async {

        final catIndex = _items.indexWhere((cat) => cat.id == id);
        if (catIndex <= 0) {
            final url = 'https://adminapps-acefe.firebaseio.com/categories/$id.json';
            await http.patch(url,
                body: json.encode({
                    'image': newCategory.image,
                    'categorie': newCategory.categorie
                }));
            _items[catIndex] = newCategory;
        } 
        else {
            print('...');
        }
    }

    Future<void> deleteCategorie(String id) async {
        final url = 'https://adminapps-acefe.firebaseio.com/categories/$id.json';
        final existingCatIndex = _items.indexWhere((cat) => cat.id == id);
        var existingCategory = _items[existingCatIndex];
        _items.removeAt(existingCatIndex);
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
            _items.insert(existingCatIndex, existingCategory);
            Fluttertoast.showToast(
                msg: 'Impossible de supprimer le produit',
                textColor: Colors.white,
                backgroundColor: Colors.black
            );
        }
        existingCategory = null;
    }
}