import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

Widget carousel(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Carousel(
            boxFit: BoxFit.cover,
            images: [
                AssetImage('images/w3.jpeg'),
                AssetImage('images/m1.jpeg'),
                AssetImage('images/c1.jpg'),
                AssetImage('images/w4.jpeg'),
                AssetImage('images/m2.jpg'),
            ],
            dotSize: 4.0,
            indicatorBgPadding: 12.0,
        ),
    );
}