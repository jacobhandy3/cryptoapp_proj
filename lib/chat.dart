import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'encrypt.dart';
import 'decrypt.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this._userName);
  final String _userName;
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {

  final TextEditingController ctrl = new TextEditingController();
  
  Widget _composeText(){
    return new IconTheme( 
      data: new IconThemeData(color: Colors.blueAccent), child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(children: <Widget>[
        new Flexible(child: new TextField(
          controller: ctrl,
          onSubmitted: _handleSubmit,
          decoration: new InputDecoration.collapsed(hintText: "Send a message"),
        ),),
        new Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: new IconButton(icon: new Icon(Icons.send), onPressed: ()=>_handleSubmit(ctrl.text),)
        )])));

  }
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
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.8,
          backgroundColor: Colors.black,
          bottom: _appBar(),),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("chat_room")
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                        snapshot.data.documents[index];

                        bool isOwnMessage = false;
                        if (document['user_name'] == widget._userName) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(
                            document['message'], document['user_name'])
                            : _message(
                            document['message'], document['user_name']);
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                  
                ),
              ),
          new Divider(
            height: 1.0,
          ),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _composeText(),
          ),]),
        
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
  
  Widget _ownMessage(String message, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(userName),
            Text(message),
          ],
        ),
        Icon(Icons.person),
      ],
    );
  }

  Widget _message(String message, String userName) {
    return Row(
      children: <Widget>[
        Icon(Icons.person),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(userName),
            Text(message),
          ],
        )
      ],
    );
  }

  _handleSubmit(String message) {
    ctrl.text = "";
    var db = Firestore.instance;
    db.collection("chat_room").add({
      "user_name": widget._userName,
      "message": message,
      "created_at": DateTime.now()
    }).then((val) {
      print("sucess");
    }).catchError((err) {
      print(err);
    });
  }
}


class ChatMessageList extends StatelessWidget{

  final String text;
  ChatMessageList({this.text});
  final String _name = "Jacob";

  @override
  Widget build(BuildContext context){
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
              child: new Text(_name[0]),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subtitle1,),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              )
            ],
          ),
        ],
      ),
    );
  }
}
