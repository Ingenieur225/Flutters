import 'package:adminapps/db/storage_service.dart';
import 'package:adminapps/models/marques/marque.dart';
import 'package:adminapps/models/marques/marque_crud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListMarques extends StatefulWidget {
    static const routeName = '/marque-list';
    @override
    _ListMarquesState createState() => _ListMarquesState();
}

class _ListMarquesState extends State<ListMarques> {

    MarqueService _marque = MarqueService();
    List _items = [];
    FireStorageService _fireStorageService = FireStorageService();
    GlobalKey<FormState> _brandFormKey = GlobalKey();
    TextEditingController brandController = TextEditingController();
    TextEditingController _brandController = TextEditingController();
    bool _loading = false;

    Future getAllMarque() async {

        setState(() => _loading = false);

        final data = await _marque.fetchAndSetMarque();
        setState(() {
            _items = data;
            _loading = true;
        });
    }

    Future<void> _refresh() async {
        final reload = await _marque.fetchAndSetMarque();
        return reload;
    }

    void _brandAlert() {
        var alert = new AlertDialog(
            content: Form(
                key: _brandFormKey,
                child: TextFormField(
                    controller: brandController,
                    validator: (value) {
                        if(value.isEmpty){
                            return 'Le champs ne peut pas être vide';
                        }
                    },
                    decoration: InputDecoration(
                        hintText: "Ajouter une marque"
                    ),
                ),
            ),
            actions: <Widget>[
                FlatButton(
                    onPressed: () {
                    Navigator.pop(context);
                    }, 
                    child: Text('Retour')
                ),
                
                FlatButton(
                    onPressed: () {
                        if(brandController.text != null){
                            _marque.addMarque(Marques(
                                marque: brandController.text
                            ));
                        }
                        Fluttertoast.showToast(
                            msg: 'Marque ajouté',
                            backgroundColor: Colors.grey,
                            textColor: Colors.white
                        );
                        Navigator.pop(context);
                    }, 
                    child: Text('Ajouter')
                ),
            ],
        );

        showDialog(context: context, builder: (_) => alert);
    }
    @override
    void initState() {
        super.initState();

        getAllMarque();
        
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'Liste des marques',
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
                        onPressed: (() => _brandAlert())
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
                            return Card(
                                elevation: 0.5,
                                margin: EdgeInsets.fromLTRB(0, 0.8, 0, 0.8),
                                child: ListTile(
                                    leading: Icon(
                                        Icons.branding_watermark,
                                        color: Colors.grey,
                                    ),
                                    title: Text(_items[i].marque),
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
                                                        var alert = new AlertDialog(
                                                            content: Form(
                                                                key: _brandFormKey,
                                                                child: TextFormField(
                                                                    controller: _brandController,
                                                                    validator: (value) {
                                                                        if(value.isEmpty){
                                                                            return 'Le champs ne peut pas être vide';
                                                                        }
                                                                    },
                                                                    decoration: InputDecoration(
                                                                        hintText: "Modifier la marque"
                                                                    ),
                                                                ),
                                                            ),
                                                            actions: <Widget>[
                                                                FlatButton(
                                                                    onPressed: () {
                                                                    Navigator.pop(context);
                                                                    }, 
                                                                    child: Text('Retour')
                                                                ),
                                                                
                                                                FlatButton(
                                                                    onPressed: () {
                                                                        if(brandController.text != null){
                                                                            _marque.updateMarque(_items[i].id, Marques(
                                                                                marque: _brandController.text
                                                                            ));
                                                                        }
                                                                        Fluttertoast.showToast(
                                                                            msg: 'Marque modifié',
                                                                            backgroundColor: Colors.grey,
                                                                            textColor: Colors.white
                                                                        );
                                                                        Navigator.pop(context);
                                                                    }, 
                                                                    child: Text('Ajouter')
                                                                ),
                                                            ],
                                                        );

                                                        showDialog(context: context, builder: (_) => alert);
                                                    }
                                                ),

                                                IconButton(
                                                    icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                    ), 
                                                    onPressed: (() =>_marque.deleteMarque(_items[i].id))
                                                ),
                                            ],
                                        ),
                                    )
                                ),
                            );
                        },
                    ),  
                )
            ),
        
        );
    }
}