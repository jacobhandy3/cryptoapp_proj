import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'home.dart';
import 'ciphers.dart';
import 'decrypt.dart';
import 'chat.dart';

class EncryptPage extends StatefulWidget {
  EncryptPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _EncryptPageState createState() => _EncryptPageState();
}
class _EncryptPageState extends State<EncryptPage> {
  final ctrllr = new TextEditingController();
    final ctrllrKey = new TextEditingController();
    String message = "This is your new message. Hold to copy.";
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
      return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Column(
            children: <Widget>[new ListTile(
                leading: const Icon(Icons.message),
                title: new TextFormField(
                  controller: ctrllr,
                  textInputAction: TextInputAction.send,
                  decoration: new InputDecoration(
                    hintText: "Input your message here",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.vpn_key),
                title: new TextFormField(
                  controller: ctrllrKey,
                  textInputAction: TextInputAction.send,
                  decoration: new InputDecoration(
                    hintText: "Input your key here",
                  ),
                ),
              ),
              new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.black,
                    color: Colors.green,
                    onPressed: (){_resetMessage(Cipher().easyCipherDecrypt(int.parse(ctrllrKey.text), ctrllr.text));},
                    child: new Text("Easy"),
                  ),
                  new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.black,
                    color: Colors.yellow,
                    onPressed: (){_resetMessage(Cipher().medCipherEncrypt(ctrllrKey.text, ctrllr.text));},
                    child: new Text("Medium"),
                  ),
                  new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.black,
                    color: Colors.red,
                    onPressed: (){_resetMessage(Cipher().hardCipherEncrypt(ctrllr.text).toString());},
                    child: new Text("Hard"),
                  ),
            ],),]),
            new Column(
              children: <Widget>[ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.new_releases, color: Colors.white),
        ),
        title: new GestureDetector( child: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),onLongPress: (){ClipboardManager.copyToClipBoard(message).then((result)
        {
          final snack = SnackBar(content: Text('Copied to Clipboard'), action: SnackBarAction(
            label: 'Undo', onPressed: (){},
          )); Scaffold.of(context).showSnackBar(snack);
        });},)
            )],
        ),
                      new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){ },
                    child: new Text("Upgrade"),
                  ),
          ])
      );}

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
  void _resetMessage(String msg) {
    setState(() {
      message = msg;
    });
  }
}
