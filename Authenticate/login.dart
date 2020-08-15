import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomapps/widgets/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class Login extends StatefulWidget {
    static const routeName = '/login';
    @override
    _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    bool loading = false;
    bool hidePass = true;
    bool isLogedIn = false;

    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _passwordTextController = TextEditingController();

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

    Future signIn() async {

        if (_formKey.currentState.validate()) {
            setState(() {
                loading = true;
            });

            try {
                firebaseAuth
                .signInWithEmailAndPassword(
                    email: _emailTextController.text, 
                    password: _passwordTextController.text
                )
                .then((user) {
                    Navigator.pushNamed(context, Home.routeName);
                });
            } 
            on PlatformException catch (error) {
                var errorMessage = 'Erreur d\'inscription';

                if (error.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
                    errorMessage = 'Email déjà utilisé.';
                }
                else if (error.toString().contains('ERROR_INVALID_EMAIL')) {
                    errorMessage = 'Addresse Email invalide';
                } 
                else if (error.toString().contains('WEAK_PASSWORD')) {
                    errorMessage = 'Mot de passe trop faible';
                } 
                else if (error.toString().contains('ERROR_USER_NOT_FOUND')) {
                    errorMessage = 'L\'utilisateur ayant cet email est introuvable';
                } 
                else if (error.toString().contains('ERROR_WRONG_PASSWORD')) {
                    errorMessage = 'Mot de passe incorrecte';
                }
                else if (error.toString().contains('ERROR_NETWORK_REQUEST_FAILED')) {
                    errorMessage = 'Oups! Connexion impossible!';
                }
                _showErrorDialog(errorMessage);
            }

            setState(() {
                loading = false;
            });
        }
    }

    Future<FirebaseUser> signInWithGoogle() async {
        final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
        );

        final AuthResult authResult = await firebaseAuth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;
        final FirebaseUser currentUser = await firebaseAuth.currentUser();

        if (currentUser != null) {
            final QuerySnapshot result = await Firestore.instance
                .collection('users')
                .where("id", isEqualTo: currentUser.uid)
                .getDocuments();
            final List<DocumentSnapshot> document = result.documents;
            
            if (document.length == 0) {
                Firestore.instance
                    .collection('users')
                    .document(currentUser.uid)
                    .setData({
                'id': currentUser.uid,
                'username': currentUser.displayName,
                'profilePicture': currentUser.photoUrl
                });
            } else {}
        }
        return user;
    }
    
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
                        )
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
                                                        controller: _emailTextController,
                                                        keyboardType: TextInputType.emailAddress,
                                                        decoration: InputDecoration(
                                                            hintText: "Email",
                                                            icon: Icon(Icons.alternate_email),
                                                        ),
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
                                            child: Material(
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Colors.white.withOpacity(0.4),
                                                elevation: 0.0,
                                                child: Padding(
                                                    padding: const EdgeInsets.only(left: 12.0),
                                                    child: TextFormField(
                                                        obscureText: hidePass,
                                                        controller: _passwordTextController,
                                                        decoration: InputDecoration(
                                                            hintText: "Mot de passe",
                                                            icon: Icon(Icons.lock_outline),
                                                        ),
                                                        validator: (value) {
                                                            if (value.isEmpty) {
                                                                return "Le champ ne peut pas être vide";
                                                            } else if (value.length < 6) {
                                                                return "6 caractères minimun";
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
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: Colors.red.shade700,
                                                elevation: 0.0,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                        signIn();
                                                    },
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: Text(
                                                        "Connexion",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20.0
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "Mot de passe oublié",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                ),
                                            ),
                                        ),
                //                          Expanded(child: Container()),

                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: (){
                                                    Navigator.pushNamed(context, SignUp.routeName);
                                                },
                                                child: Text(
                                                    "Inscription", 
                                                    textAlign: TextAlign.center, 
                                                    style: TextStyle(color: Colors.red),
                                                ),
                                            )
                                        ),
                                    ],
                                    )
                                ),
                            ),
                        ),
                    ),

                    // Visibility is used to show/hide widget
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