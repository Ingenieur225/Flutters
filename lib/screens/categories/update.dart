import 'dart:io';
import 'package:adminapps/db/storage_service.dart';
import 'package:adminapps/models/categories/category.dart';
import 'package:adminapps/models/categories/category_crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCategorie extends StatefulWidget {

    final String id;
    final String categorie;
    final String image;

    UpdateCategorie(this.id, this.categorie, this.image);
    
    static const routeName = '/update';
    @override
    _UpdateCategorie createState() => _UpdateCategorie();
}

class _UpdateCategorie extends State<UpdateCategorie> {

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    CategorieService _category = CategorieService();
    TextEditingController _categoryController = TextEditingController();
    FireStorageService _fireStorageService =FireStorageService();
    File _image;
    bool loading = false;

    getCategorieData() {  
        _categoryController.text = widget.categorie;
    }

    void _selectImage(Future<File> pickImage) async {
        File tempImg = await pickImage;
        setState(() => _image = tempImg);
    }

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

    Widget _displayChild1() {
        if(_image == null) {
            return Padding(
                padding: EdgeInsets.fromLTRB(8.0, 40, 8.0, 40),
                child: FutureBuilder(
                    future: _getImage(context, widget.image),
                    builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                            return Container(
                                child: snapshot.data,
                            );

                        return Container();
                    },
                )
            );
        }
        else {
           return Image.file(
                _image, 
                fit: BoxFit.cover
            );
        }
    }

    Future upload() async {
        if(_formKey.currentState.validate()) {

            if(_image != null) {
                setState(() => loading = true);

                String imageUrl;

                final FirebaseStorage storage = FirebaseStorage.instance;

                final String picture = '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
                StorageUploadTask task = storage.ref().child(picture).putFile(_image);

                StorageTaskSnapshot snapshot = await task.onComplete.then((snaps) => snaps);

                task.onComplete.then((snapshot) async {
                    imageUrl = await snapshot.ref.getDownloadURL();
                });

                final imageList = picture;

                _category.updateCategoriet(widget.id, Category(
                    categorie: _categoryController.text,
                    image: imageList
                ));
                
                _formKey.currentState.reset();
                
                setState(() => loading = true);
                
                Fluttertoast.showToast(
                    msg: 'Categorie modifier',
                    backgroundColor: Colors.grey,
                    textColor: Colors.white
                );

                Navigator.of(context).pop();
            }
        }
    }

    @override
    void initState() {
        super.initState();

        getCategorieData();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ), 
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                    'Ajouter une categorie',
                    style: TextStyle(
                        color: Colors.black
                    ),
                ),
                elevation: 0.1,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(
                            Icons.save,
                            color: Colors.black,
                        ), 
                        onPressed: (() => upload())
                    )
                ],
            ),

            body: Form(
                key: _formKey,
                child: loading ? Center(child: CircularProgressIndicator()) : Column(
                    children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 40.0, bottom: 12.0),
                            child: Text(
                                'Le nom de la categorie ne doit pas dépasser 30 caractères',
                                style: TextStyle(
                                    color: Colors.red
                                ),
                            ),
                        ),

                        Row(
                            children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: OutlineButton(
                                                onPressed: () {
                                                    _selectImage(ImagePicker.pickImage(source: ImageSource.gallery));
                                                    },
                                                borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.8),
                                                    width: 1.0
                                                ),
                                                child: _displayChild1()
                                        ),
                                    )
                                ),

                                Container(
                                    width: MediaQuery.of(context).size.width / 1.8,
                                    child: TextFormField(
                                        controller: _categoryController,
                                        decoration: InputDecoration(
                                            hintText: 'Entrez le nom de la categorie'
                                        ),
                                        validator: (value) {
                                            if (value.isEmpty) {
                                                return 'Le champ ne peut pas être vide';
                                            }
                                            else if (value.length > 30) {
                                                return 'Pas plus de 30 caractères';
                                            }
                                        },
                                    ),
                                )
                            ],
                        ),
                    ],
                ),
            ),
        );
    }
}