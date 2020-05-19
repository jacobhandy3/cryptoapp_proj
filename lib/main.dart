import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
var currentUserEmail;
//var _scaffoldContext;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptoapp',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        brightness: Brightness.dark
      ),
      home: HomePage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential) as FirebaseUser;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
          await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({'nickname': firebaseUser.displayName, 'photoUrl': firebaseUser.photoUrl, 'id': firebaseUser.uid});

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  currentUserId: firebaseUser.uid,
                )),
      );
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var _textStyleGrey = new TextStyle(fontSize: 12.0, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cryptoapp',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            new Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
            child: new Text(
              'Cryptoapp',
              style: new TextStyle(fontFamily: 'Roboto', fontSize: 50.0),
            ),
          ),
          _userIDEditContainer(),
          _passwordEditContainer(),
          _loginContainer(),
          
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10.0),
        child: new FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'SIGN IN WITH GOOGLE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
        color: Colors.blue,
      ),
            ],
          ),
          ],
        ));
  }

  Widget _userIDEditContainer() {
    return new Container(
      child: new TextField(
        controller: usernameController,
        decoration: new InputDecoration(
            hintText: 'Email',
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black),
            ),
            isDense: true),
        style: _textStyleGrey,
        
      ),
    );
  }

  Widget _passwordEditContainer() {
    return new Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: new TextField(
        controller: passwordController,
        obscureText: true,
        decoration: new InputDecoration(
            hintText: 'Password',
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black),
            ),
            isDense: true),
        style: _textStyleGrey,
      ),
    );
  }

  Widget _loginContainer() {
    return new GestureDetector(
      onTap: _login,
      child: new Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10.0),
        width: 250.0,
        height: 40.0,
        child: new Text(
          "Log In",
          style: new TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
      ),
    );
  }
  Future<String> login(context)
  async {
    String username = usernameController.text;
    String password = passwordController.text;
    var url = "";
    
    var resp = await http.get(url);
    var token = jsonDecode(resp.body)["token"];
    return token;
  }
    void log_process(var context)
  async {
    var token = await login(context);
    // var allposts = await getPosts(token);
    // var myposts = await getmyPosts(token);
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

    void _login() {
    if (usernameController.text.isEmpty) {
      _showEmptyDialog("Type something");
    } else if (passwordController.text.isEmpty) {
      _showEmptyDialog("Type something");
    } else {
      log_process(context);
    }
  }

    _showEmptyDialog(String title) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              content: new Text("$title can't be empty"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("OK"))
              ],
            ));
  }
}