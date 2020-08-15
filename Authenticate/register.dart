import 'package:ecomapps/widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
    static const routeName = '/signUp';
    @override
    _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
    
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _passwordTextController = TextEditingController();
    TextEditingController _nameTextController = TextEditingController();
    String gender;
    String groupValue = "Homme";
    bool hidePass = true;
    bool loading = false;

    
    void _showErrorDialog(String message) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                title: Text('Une erreur s\'est produite!'),
                content: Text(message),
                actions: <Widget>[
                    FlatButton(
                        child: Text(
                            'Ok', 
                            style: TextStyle(
                                color: Colors.black
                            ),
                        ),
                        onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                                this.loading = false;
                            });
                        },
                    )
                ],
            ),
        );
    }

    valueChanged(e) {
        setState(() {
            if (e == "Homme") {
                groupValue = e;
                gender = e;
            } else if (e == "Femme") {
                groupValue = e;
                gender = e;
            }
        });
    }

    // Future signUp() async {

    //     UserUpdateInfo updateInfo = UserUpdateInfo();
    //     updateInfo.displayName = _nameTextController.text;

    //     if (_formKey.currentState.validate()) {
    //         setState(() {
    //             loading = true;
    //         });

    //         try {
    //             firebaseAuth
    //             .createUserWithEmailAndPassword(
    //                 email: _emailTextController.text, 
    //                 password: _passwordTextController.text
    //             )
    //             .then((user) async {
    //                 // await user.user.updateProfile(updateInfo);

    //                 _userServices.createUser(
    //                     fullName: _nameTextController.text,
    //                     email: _emailTextController.text,
    //                     gender: gender,
    //                 );
    //                 Navigator.pushNamed(context, Home.routeName);
    //             });
    //         } 
    //         on PlatformException catch (error) {
    //             var errorMessage = 'Erreur d\'inscription';

    //             if (error.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
    //                 errorMessage = 'Email déjà utilisé.';
    //             }
    //             else if (error.toString().contains('ERROR_INVALID_EMAIL')) {
    //                 errorMessage = 'Addresse Email invalide';
    //             } 
    //             else if (error.toString().contains('WEAK_PASSWORD')) {
    //                 errorMessage = 'Mot de passe trop faible';
    //             } 
    //             else if (error.toString().contains('ERROR_USER_NOT_FOUND')) {
    //                 errorMessage = 'L\'utilisateur ayant cet email est introuvable';
    //             } 
    //             else if (error.toString().contains('ERROR_WRONG_PASSWORD')) {
    //                 errorMessage = 'Mot de passe incorrecte';
    //             }
    //             else if (error.toString().contains('ERROR_NETWORK_REQUEST_FAILED')) {
    //                 errorMessage = 'Oups! Connexion impossible!';
    //             }
    //             _showErrorDialog(errorMessage);
    //         }

    //         setState(() {
    //             loading = false;
    //         });
    //     }
    // }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Stack(
                children: <Widget>[
                    Image.asset(
                        'images/back.jpg',
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                    ),
                    Container(
                        color: Colors.black.withOpacity(0.8),
                        width: double.infinity,
                        height: double.infinity,
                    ),
                    Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                            'images/lg.png',
                            width: 280.0,
                            height: 240.0,
                        ),
                    ),
                    Center(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 200.0),
                                child: Center(
                                    child: Form(
                                        key: _formKey,
                                        child: ListView(
                                        children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                                                child: Material(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white.withOpacity(0.4),
                                                    elevation: 0.0,
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(left: 12.0),
                                                        child: TextFormField(
                                                            controller: _nameTextController,
                                                            decoration: InputDecoration(
                                                                hintText: "Nom & Prénoms",
                                                                icon: Icon(Icons.person_outline),
                                                                border: InputBorder.none),
                                                            validator: (value) {
                                                            if (value.isEmpty) {
                                                                return "Le champ ne peut pas être vide";
                                                            }
                                                            return null;
                                                            },
                                                        ),
                                                    ),
                                                ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                                                child: Material(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white.withOpacity(0.4),
                                                    elevation: 0.0,
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(left: 12.0),
                                                        child: TextFormField(
                                                            controller: _emailTextController,
                                                            keyboardType: TextInputType.emailAddress,
                                                            decoration: InputDecoration(
                                                                hintText: "Email",
                                                                icon: Icon(Icons.alternate_email),
                                                                border: InputBorder.none),
                                                                validator: (value) {
                                                                if (value.isEmpty) {
                                                                    Pattern pattern =
                                                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                                    RegExp regex = new RegExp(pattern);
                                                                    if (!regex.hasMatch(value))
                                                                        return 'Le champ ne peut pas être vide';
                                                                    else
                                                                        return null;
                                                                }
                                                            },
                                                        ),
                                                    ),
                                                ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                                                child: new Container(
                                                    color: Colors.white.withOpacity(0.4),
                                                    child: Row(
                                                        children: <Widget>[
                                                            Expanded(
                                                                child: ListTile(
                                                                    title: Text(
                                                                        "Homme",
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(color: Colors.white),
                                                                    ),
                                                                    trailing: Radio(
                                                                        value: "Homme",
                                                                        groupValue: groupValue,
                                                                        onChanged: (e) => valueChanged(e)),
                                                                    )),
                                                                    Expanded(
                                                                        child: ListTile(
                                                                    title: Text(
                                                                        "Femme",
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(color: Colors.white),
                                                                    ),
                                                                    trailing: Radio(
                                                                        value: "Femme",
                                                                        groupValue: groupValue,
                                                                        onChanged: (e) => valueChanged(e)
                                                                    ),
                                                                )
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                                                child: Material(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white.withOpacity(0.4),
                                                    elevation: 0.0,
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(left: 12.0),
                                                        child: ListTile(
                                                            title: TextFormField(
                                                                controller: _passwordTextController,
                                                                obscureText: hidePass,
                                                                decoration: InputDecoration(
                                                                    hintText: "Mot de passe",
                                                                    icon: Icon(Icons.lock_outline),
                                                                    border: InputBorder.none),
                                                                validator: (value) {
                                                                    if (value.isEmpty) {
                                                                    return "Le champ ne peut pas être vide";
                                                                    } else if (value.length < 6) {
                                                                    return "6 caractères minimun";
                                                                    }
                                                                    return null;
                                                                },
                                                            ),
                                                            trailing: IconButton(
                                                                icon: Icon(Icons.remove_red_eye),
                                                                onPressed: () {
                                                                    setState(() {
                                                                        hidePass = !hidePass;
                                                                    });
                                                                }
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                            ),


                                            Padding(
                                                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                                                child: Material(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white.withOpacity(0.4),
                                                    elevation: 0.0,
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(left: 12.0),
                                                        child: ListTile(
                                                            title: TextFormField(
                                                                obscureText: hidePass,
                                                                decoration: InputDecoration(
                                                                    hintText: "Confirmer le mot de passe",
                                                                    icon: Icon(Icons.lock_outline),
                                                                    border: InputBorder.none),
                                                                validator: (value) {
                                                                    if (value != _passwordTextController.text) {
                                                                        return "Les mots de passe ne sont pas identiques";
                                                                    }
                                                                    return null;
                                                                },
                                                            ),
                                                            trailing: IconButton(
                                                                icon: Icon(Icons.remove_red_eye),
                                                                onPressed: () {
                                                                    setState(() {
                                                                        hidePass = !hidePass;
                                                                    });
                                                                }
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                            ),

                                            Padding(
                                                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                                                child: Material(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: Colors.red.shade700,
                                                    elevation: 0.0,
                                                    child: MaterialButton(
                                                        onPressed: () {
                                                            // signUp();
                                                        },
                                                        minWidth: MediaQuery.of(context).size.width,
                                                        child: Text(
                                                        "Inscription",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20.0),
                                                        ),
                                                    )
                                                ),
                                            ),

                                            Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                    onTap: () {
                                                        Navigator.pushNamed(context, Login.routeName);
                                                    },
                                                    child: Text(
                                                        "Connexion",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.red),
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    ),
                    Visibility(
                        visible: loading ?? true,
                        child: Center(
                            child: Container(
                                alignment: Alignment.center,
                                color: Colors.white.withOpacity(0.9),
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                            ),
                        ),
                    )
                ],
            ),
        );
    }

}