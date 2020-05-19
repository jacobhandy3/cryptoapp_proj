import 'package:flutter/material.dart';
import 'chat.dart';
import 'encrypt.dart';
import 'decrypt.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.currentUserId}) : super(key: key);
  final currentUserId;
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  _appBar(){
    return new PreferredSize(
        child: new Container(
          color: Colors.black,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.blue,
                iconSize: 25.0,
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));},
              ),
              new Text(
              '¢ryptoapp',
              style: new TextStyle(fontSize: 30.0, color: Colors.blue),
            ),
              new IconButton(
                icon: new Icon(Icons.person), color: Colors.blue,
                iconSize: 25.0,
                onPressed: () {},
              ),
            ],
          ),
        ),
        preferredSize: null);
  }
  _body(){
    return new Center(child: new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      new Text(
                "Welcome to Cryptoapp!",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  fontFamily: 'Roboto',
                ),
              ),
              new Text(
                "Instructions:",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  fontFamily: 'Roboto',
                ),
              ),
              new ListTile(
                leading: new Text("Easy"),
                title: new Text("Message: take out any spaces and punctuation"),
                subtitle: new Text("Key: any number you want"),
              ),
              new ListTile(
                leading: new Text("Medium"),
                title: new Text("Message: any message you want"),
                subtitle: new Text("Key: think of this as a password"),
              ),
              new ListTile(
                leading: new Text("Hard"),
                title: new Text("Message: take out any punctuation"),
                subtitle: new Text("Key: none"),
              ),
    ],),);
    /* return new StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
      itemExtent: 80.0,
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
    );
      }); */
  }
  @override
  Widget build(BuildContext context) {
      return new Scaffold(
    appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.8,
          backgroundColor: Colors.black,
          bottom: _appBar(),),
    body: _body(),
    bottomNavigationBar: BottomAppBar(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.home), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));},),
          IconButton(icon: Icon(Icons.lock), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => EncryptPage()));},),
          IconButton(icon: Icon(Icons.lock_open), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DecryptPage()));},),
          IconButton(icon: Icon(Icons.chat), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen("jakemh7")));},),
        ],
      )
    ),
  );
  }
}

