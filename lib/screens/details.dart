import 'package:adminapps/db/storage_service.dart';
import 'package:adminapps/screens/products/update.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {

    final String id;
    final String titre;
    final double prix;
    final int quantite;
    final String image;
    final String description;
    final String categorie;

    Details(this.id, this.titre, this.categorie, this.image, this.description, this.prix, this.quantite);

    static const routeName = 'details';
    @override
    _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

    FireStorageService _fireStorageService = FireStorageService();

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
    
    @override
    Widget build(BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                    title: Text(
                        'Details Products',
                        style: TextStyle(
                            color: Colors.black
                        ),),
                    backgroundColor: Colors.white,
                    leading: IconButton(
                        icon: Icon(Icons.close),
                        color: Colors.black, 
                        onPressed: () => Navigator.of(context).pop()
                    ),
                    elevation: 0.1,
                ),

            body: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        FutureBuilder(
                            future: _getImage(context, "${widget.image}"),
                            builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done)
                                    return Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height / 3,
                                        child: snapshot.data
                                    );

                                return Container();
                            },
                        ),

                        Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                            child: Text(
                                "${widget.titre}",
                                style: TextStyle(
                                    fontSize: 18.0
                                ),
                            ),
                        ),
                        
                        ListTile(
                            title: Text('Info'),
                            subtitle: Column(
                                children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                        child: Row(
                                            children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(left: 8.0),
                                                    child: Text(
                                                        'categorie: ',
                                                        style: TextStyle(
                                                            color: Colors.red
                                                        ),
                                                    ),

                                                ),
                                                Text(widget.categorie)
                                            ],
                                        ),
                                    ),
                                    Divider(),

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(right: 8.0),
                                                child: Row(
                                                    children: <Widget>[
                                                        Text(
                                                            'prix: ',
                                                            style: TextStyle(
                                                                color: Colors.red
                                                            ),
                                                        ),
                                                        Text('${widget.prix}'),
                                                    ],
                                                )
                                            ),
                                            
                                            Padding(
                                                padding: EdgeInsets.only(right: 8.0),
                                                child: Row(
                                                    children: <Widget>[
                                                        Text(
                                                            'quantite: ',
                                                            style: TextStyle(
                                                                color: Colors.red
                                                            ),
                                                        ),
                                                        Text('${widget.quantite}'),
                                                    ],
                                                ),
                                            ),
                                            
                                        ],
                                    ),
                                ],
                            ),
                        ),

                        Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: ListTile(
                                title: Text('Description'),
                                subtitle: Text(widget.description),
                            ),
                        ),
                    ],
                ),
            )
        );
    }
}