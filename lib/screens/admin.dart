import 'package:adminapps/screens/categories/read.dart';
import 'package:adminapps/screens/marques/read.dart';
import 'package:adminapps/screens/products/read.dart';
import 'package:flutter/material.dart';
import 'products/read.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
    @override
    _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

    Page _selectedPage = Page.dashboard;
    MaterialColor active = Colors.red;
    MaterialColor notActive = Colors.grey;
    TextEditingController categoryController = TextEditingController();
    TextEditingController brandController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
                children: <Widget>[
                    Expanded(
                        child: FlatButton.icon(
                            onPressed: () {
                                setState(() => _selectedPage = Page.dashboard);
                            },
                            icon: Icon(
                                Icons.dashboard,
                                color: _selectedPage == Page.dashboard ? active : notActive,
                            ),
                            label: Text('Dashboard')
                        ),
                    ),
                    Expanded(
                        child: FlatButton.icon(
                            onPressed: () {
                                setState(() => _selectedPage = Page.manage);
                            },
                            icon: Icon(
                                Icons.sort,
                                color: _selectedPage == Page.manage ? active : notActive,
                            ),
                            label: Text('Manage'),
                        ),
                    ),
                ],
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
        ),
        body: _loadScreen());
    }

    Widget _loadScreen() {
        switch (_selectedPage) {
            case Page.dashboard:
                return Column(
                    children: <Widget>[
                        ListTile(
                            title: Text(
                                'Revenue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24.0, 
                                    color: Colors.grey
                                ),
                            ),
                            subtitle: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(
                                    Icons.attach_money,
                                    size: 30.0,
                                    color: Colors.green,
                                ),
                                label: Text(
                                    '12,000',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30.0, 
                                        color: Colors.green
                                    ),
                                ),
                            ),
                        ),

                        Expanded(
                            child: GridView(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Card(
                                            child: ListTile(
                                                title: FlatButton.icon(
                                                    onPressed: null,
                                                    icon: Icon(Icons.people_outline),
                                                    label: Text("Users")
                                                ),
                                                subtitle: Text(
                                                    '7',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: active, 
                                                        fontSize: 60.0
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Card(
                                            child: ListTile(
                                                title: Container(
                                                    height: MediaQuery.of(context).size.height / 13,
                                                  child: ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: <Widget>[
                                                          FlatButton.icon(
                                                              onPressed: null,
                                                              icon: Icon(Icons.category),
                                                              label: Text(
                                                                  "Categories",
                                                                  textAlign: TextAlign.center,
                                                              ),
                                                          ),
                                                      ],
                                                  ),
                                                ),
                                                subtitle: Text(
                                                    '23',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: active, fontSize: 60.0),
                                                ),
                                            ),
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Card(
                                        child: ListTile(
                                                title: Container(
                                                    height: MediaQuery.of(context).size.height / 13,
                                                  child: ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: <Widget>[
                                                          FlatButton.icon(
                                                              onPressed: null,
                                                              icon: Icon(Icons.track_changes),
                                                              label: Text(
                                                                  "Products",
                                                                  textAlign: TextAlign.center,
                                                              ),
                                                          ),
                                                      ],
                                                  ),
                                                ),
                                                subtitle: Text(
                                                    '120',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: active, fontSize: 60.0),
                                                ),
                                            ),
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Card(
                                            child: ListTile(
                                                title: FlatButton.icon(
                                                    onPressed: null,
                                                    icon: Icon(Icons.tag_faces),
                                                    label: Text("Sold")
                                                ),
                                                subtitle: Text(
                                                    '13',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: active, fontSize: 60.0),
                                                ),
                                            ),
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Card(
                                        child: ListTile(
                                            title: FlatButton.icon(
                                                onPressed: null,
                                                icon: Icon(Icons.shopping_cart),
                                                label: Text("Orders")),
                                            subtitle: Text(
                                                '5',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: active, fontSize: 60.0),
                                            )),
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Card(
                                            child: ListTile(
                                                title: FlatButton.icon(
                                                    onPressed: null,
                                                    icon: Icon(Icons.close),
                                                    label: Text("Return"),
                                                ),
                                                subtitle: Text(
                                                    '0',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: active, fontSize: 60.0),
                                                ),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                );
                break;
            case Page.manage:
                return ListView(
                    children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.change_history),
                            title: Text("Liste des produits"),
                            onTap: () {
                                Navigator.pushNamed(context, ListProduct.routeName);
                            },
                        ),
                        Divider(),
                        ListTile(
                            leading: Icon(Icons.add_circle),
                            title: Text("Liste des categories"),
                            onTap: () {
                                Navigator.pushNamed(context, ListCategory.routeName);
                            },
                        ),
                        Divider(),
                        ListTile(
                            leading: Icon(Icons.add_circle_outline),
                            title: Text("Liste des marques"),
                            onTap: () {
                                Navigator.pushNamed(context, ListMarques.routeName);
                            },
                        )
                    ],
                );
                break;
            default:
                return Container();
        }
    }
}
