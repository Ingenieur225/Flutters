import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'marque.dart';

class MarqueService {

    List<Marques> _items = [];

    fetchAndSetMarque() async {
        const url = 'https://adminapps-acefe.firebaseio.com/marques.json';
        try {
            final response = await http.get(url);
            final extractedData = json.decode(response.body) as Map<String, dynamic>;
            final List<Marques> loadedMarque = [];
            extractedData.forEach((marqueId, marqueData) {
                loadedMarque.insert(0, Marques(
                    id: marqueId,
                    marque: marqueData['marque'],
                ));
            });
            _items = loadedMarque;
            return _items;
        }
        catch (error) {
            print(error);
        }
    }

    Future<void> addMarque(Marques marque) async {
        const url = 'https://adminapps-acefe.firebaseio.com/marques.json';
        try {
            final response = await http.post(url, body: json.encode(
                {
                    'marque': marque.marque
                }),
            );
            final newMarque = Marques(
                id: json.decode(response.body)['name']
            );
            _items.add
            (newMarque);
            
        } 
        catch (error) {
            print(error);
        }
    }

    Future<void> updateMarque(String id, Marques newMarque) async {

        final catIndex = _items.indexWhere((cat) => cat.id == id);
        if (catIndex <= 0) {
            final url = 'https://adminapps-acefe.firebaseio.com/marques/$id.json';
            await http.patch(url,
                body: json.encode({
                    'marque': newMarque.marque
                }));
            _items[catIndex] = newMarque;
        } 
        else {
            print('...');
        }
    }

    Future<void> deleteMarque(String id) async {
        final url = 'https://adminapps-acefe.firebaseio.com/marques/$id.json';
        final existingmarqueIndex = _items.indexWhere((marque) => marque.id == id);
        var existingMarque = _items[existingmarqueIndex];
        _items.removeAt(existingmarqueIndex);
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
            _items.insert(existingmarqueIndex, existingMarque);
            Fluttertoast.showToast(
                msg: 'Impossible de supprimer le produit',
                textColor: Colors.white,
                backgroundColor: Colors.black
            );
        }
        existingMarque = null;
    }
}