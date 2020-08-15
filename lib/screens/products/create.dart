import 'dart:io';
import 'package:adminapps/models/products/product.dart';
import 'package:adminapps/models/products/product_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../db/category.dart';
import '../../db/brand.dart';

class AddProduct extends StatefulWidget {
    static const routeName = '/add-product';
    @override
    _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

    CategoryService _categoryService = CategoryService();
    BrandService _brandService = BrandService();
    ProductService _products = ProductService();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController productNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    final priceController = TextEditingController();
    List<DocumentSnapshot> brands = [];
    List<DocumentSnapshot> categories = [];
    List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
    List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
    String _currentBrand;
    String _currentCategory;
    File _image1;
    File _image2;
    File _image3;
    bool loading = false;
    

                //////////////////////////////////////////////////
    ///////////// RECUPERATIONS DES CATEGORIES DANS LE DROPDOWN /////////////////
              /////////////////////////////////////////////////
    List<DropdownMenuItem<String>> getCategoriesDropDown() {
        List<DropdownMenuItem<String>> items = [];
        for(int i = 0; i < categories.length; i++) {
            items.insert(0,
                DropdownMenuItem(
                    child: Text(categories[i].data['category']),
                    value: categories[i].data['category'],
                )
            );
        }
        return items;
    }



                //////////////////////////////////////////////////
    ///////////// RECUPERATIONS DES BRANDS DANS LE DROPDOWN /////////////////
              /////////////////////////////////////////////////
    List<DropdownMenuItem<String>> getBrandsDropDown() {
        List<DropdownMenuItem<String>> items = [];
        for(int i = 0; i < brands.length; i++) {
            items.insert(0, 
                DropdownMenuItem(
                    child: Text(brands[i].data['brand']),
                    value: brands[i].data['brand'],
                )
            );
        }
        return items;
    }


                //////////////////////////////////
    ///////////// RECUPERATIONS DES CATEGORIES /////////////////
              //////////////////////////////////
    _getCategories() async {
        List<DocumentSnapshot> data = await _categoryService.getCategory();
        setState(() {
            categories = data;
            categoriesDropDown = getCategoriesDropDown();  // Appel des items de la liste
            _currentCategory = categories[0].data['category'];
        });
    }


                /////////////////////////////
    ///////////// RECUPERATIONS DES BRANDS /////////////////
              /////////////////////////////
    _getBrands() async {
        List<DocumentSnapshot> data = await _brandService.getBrands();
        setState(() {
            brands = data;
            brandsDropDown = getBrandsDropDown();  // Appel des items de la liste
            _currentBrand = brands[0].data['brand'];
        });
    }


    changeSelectCategory(String selectedCategory) {
        setState(() => _currentCategory = selectedCategory);
    }


    changeSelectBrands(String selectedBrand) {
        setState(() => _currentBrand = selectedBrand);
    }

    void _selectImage(Future<File> pickImage, int imageNumber) async {
        File tempImg = await pickImage;
        switch(imageNumber) {
            case 1:
                setState(() => _image1 = tempImg);
                break;
            case 2:
                setState(() => _image2 = tempImg);
                break;
            case 3:
                setState(() => _image3 = tempImg);

        }
    }

    Widget _displayChild1() {
        if(_image1 == null) {
            return Padding(
                padding: EdgeInsets.fromLTRB(8.0, 40, 8.0, 40),
                child: Icon(
                    Icons.add,
                    color: Colors.grey,
                ),
            );
        }
        else {
           return Image.file(
                _image1, 
                fit: BoxFit.cover
            );
        }
    }

    Widget _displayChild2() {
        if(_image2 == null) {
            return Padding(
                padding: EdgeInsets.fromLTRB(8.0, 40, 8.0, 40),
                child: Icon(
                    Icons.add,
                    color: Colors.grey,
                ),
            );
        }
        else {
            return Image.file(
                _image2,
                fit: BoxFit.cover
            );
        }
    }

    Widget _displayChild3() {
        if(_image3 == null) {
            return Padding(
                padding: EdgeInsets.fromLTRB(8.0, 40, 8.0, 40),
                child: Icon(
                    Icons.add,
                    color: Colors.grey,
                ),
            );
        }
        else {
            return Image.file(
                _image3,
                fit: BoxFit.cover
            );
        }
    }

    Future upload() async {
        if(_formKey.currentState.validate()) {

            if(_image1 != null && _image2 != null && _image3 != null) {
                setState(() => loading = true);

                String imageUrl1;
                String imageUrl2;
                String imageUrl3;

                final FirebaseStorage storage = FirebaseStorage.instance;

                final String picture1 = '1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
                StorageUploadTask task1 = storage.ref().child(picture1).putFile(_image1);

                final String picture2 = '2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
                StorageUploadTask task2 = storage.ref().child(picture2).putFile(_image2);

                final String picture3 = '3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
                StorageUploadTask task3 = storage.ref().child(picture3).putFile(_image3);

                StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snaps) => snaps);
                StorageTaskSnapshot snapshot2 = await task2.onComplete.then((snaps) => snaps);
                StorageTaskSnapshot snapshot3 = await task3.onComplete.then((snaps) => snaps);

                task3.onComplete.then((snapshot3) async {
                    imageUrl1 = await snapshot1.ref.getDownloadURL();
                    imageUrl2 = await snapshot2.ref.getDownloadURL();
                    imageUrl3 = await snapshot3.ref.getDownloadURL();
                });

                List<String> imageList = [picture1, picture2, picture3];

                _products.addProduct(Product(
                    titre: productNameController.text,
                    prix: double.parse(priceController.text),
                    quantite: int.parse(quantityController.text),
                    image: imageList,
                    description: descriptionController.text,
                    categorie: _currentCategory,
                ));
                
                _formKey.currentState.reset();
                
                setState(() => loading = true);
                
                Fluttertoast.showToast(
                    msg: 'Produit ajouté',
                    backgroundColor: Colors.grey,
                    textColor: Colors.white
                );

                Navigator.of(context).pop();
            }
        }
    }

                //////////////////
    ///////////// AU CHARGEMENT /////////////////
              ///////////////////
    @override
    void initState() {
        super.initState();

        _getCategories(); // Appel de lu future _getCategories()

        _getBrands();
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
                    'Add products',
                    style: TextStyle(
                        color: Colors.black
                    ),
                ),
                elevation: 0.1,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.save), 
                        onPressed: (() => upload())
                    )
                ],
            ),

            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: loading ? Center(child: CircularProgressIndicator()) : Column(
                        children: <Widget>[
                            Row(
                                children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: OutlineButton(
                                                    onPressed: () {
                                                        _selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 1);
                                                        },
                                                    borderSide: BorderSide(
                                                        color: Colors.grey.withOpacity(0.8),
                                                        width: 1.0
                                                    ),
                                                    child: _displayChild1()
                                            ),
                                        ),
                                    ),

                                    Expanded(
                                        child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: OutlineButton(
                                                    onPressed: () {
                                                        _selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 2);
                                                    },
                                                    borderSide: BorderSide(
                                                        color: Colors.grey.withOpacity(0.8),
                                                        width: 1.0
                                                    ),
                                                    child: _displayChild2()
                                            ),
                                        ),
                                    ),

                                    Expanded(
                                        child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: OutlineButton(
                                                    onPressed: () {
                                                        _selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 3);
                                                    },
                                                    borderSide: BorderSide(
                                                        color: Colors.grey.withOpacity(0.8),
                                                        width: 1.0
                                                    ),
                                                    child: _displayChild3()
                                            ),
                                        ),
                                    ),
                                ],
                            ),

                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    'Le nom du produit ne doit pas dépasser 100 caractères',
                                    style: TextStyle(
                                        color: Colors.red
                                    ),
                                )
                            ),

                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: productNameController,
                                    decoration: InputDecoration(
                                        hintText: 'Product name'
                                    ),
                                    validator: (value) {
                                        if (value.isEmpty) {
                                            return 'Le champ ne peut pas être vide';
                                        }
                                        else if (value.length > 100) {
                                            return 'Pas plus de 100 caractères';
                                        }
                                    },
                                ),
                            ),
                            
                            Row(
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            'Category: ',
                                            style: TextStyle(
                                                color: Colors.red
                                            ),
                                        ),

                                    ),
                                    DropdownButton(
                                        items: categoriesDropDown, 
                                        onChanged: changeSelectCategory,
                                        value: _currentCategory,
                                    ),

                                    Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            'Brands: ',
                                            style: TextStyle(
                                                color: Colors.red
                                            ),
                                        ),

                                    ),
                                    DropdownButton(
                                        items: brandsDropDown, 
                                        onChanged: changeSelectBrands,
                                        value: _currentBrand,
                                    ),
                                ],
                            ),

                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                    minLines: 10,
                                    maxLines: 1000,
                                    controller: descriptionController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Description'
                                    ),
                                    validator: (value) {
                                        if (value.isEmpty) {
                                            return 'Le champ ne peut pas être vide';
                                        }
                                    },
                                ),
                            ),

                            Row(
                                children: <Widget>[
                                    Container(
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 40.0),
                                            child: TextFormField(
                                                controller: quantityController,
                                                keyboardType: TextInputType.numberWithOptions(),
                                                decoration: InputDecoration(
                                                    hintText: 'Quantity'
                                                ),
                                                validator: (value) {
                                                    if (value.isEmpty) {
                                                        return 'Le champ ne peut pas être vide';
                                                    }
                                                },
                                            ),
                                        ),
                                    ),

                                    Container(
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                                controller: priceController,
                                                keyboardType: TextInputType.numberWithOptions(),
                                                decoration: InputDecoration(
                                                    hintText: 'Price'
                                                ),
                                                validator: (value) {
                                                    if (value.isEmpty) {
                                                        return 'Le champ ne peut pas être vide';
                                                    }
                                                },
                                            ),
                                        ),
                                    )
                                
                                ],
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}