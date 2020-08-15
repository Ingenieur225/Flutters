import 'package:adminapps/db/storage_service.dart';
import 'package:adminapps/models/categories/category_crud.dart';
import 'package:adminapps/screens/categories/add.dart';
import 'package:flutter/material.dart';
import 'update.dart';

class ListCategory extends StatefulWidget {
    static const routeName = '/category-list';
    @override
    _ListCategoryState createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {

    CategorieService _category = CategorieService();
    List _items = [];
    FireStorageService _fireStorageService = FireStorageService();
    bool _loading = false;

    Future getAllCategorie() async {

        setState(() => _loading = false);

        final data = await _category.fetchAndSetCategorie();
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
        final reload = await _category.fetchAndSetCategorie();
        return reload;
    }

    @override
    void initState() {
        super.initState();

        getAllCategorie();
        
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'Liste des categories',
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
                        onPressed: () => Navigator.pushNamed(context, AddCategory.routeName)
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
                                    leading: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.transparent,
                                        child: FutureBuilder(
                                            future: _getImage(context, _items[i].image),
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
                                    title: Text(_items[i].categorie),
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
                                                            return UpdateCategorie(_items[i].id, _items[i].categorie, _items[i].image);
                                                        }));
                                                    }
                                                ),

                                                IconButton(
                                                    icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                    ), 
                                                    onPressed: (() =>_category.deleteCategorie(_items[i].id))
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