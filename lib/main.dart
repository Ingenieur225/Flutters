import 'package:adminapps/screens/marques/read.dart';
import 'package:adminapps/screens/products/create.dart';
import 'package:adminapps/screens/categories/read.dart';
import 'package:flutter/material.dart';
import 'screens/categories/add.dart';
import 'screens/admin.dart';
import 'screens/products/read.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Admin',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            home: Admin(),
            routes: {
                AddProduct.routeName: (ctx) => AddProduct(),
                AddCategory.routeName: (ctx) => AddCategory(),
                ListProduct.routeName: (ctx) => ListProduct(),
                ListCategory.routeName: (ctx) => ListCategory(),
                ListMarques.routeName: (ctx) => ListMarques(),
            },
        );
    }
}