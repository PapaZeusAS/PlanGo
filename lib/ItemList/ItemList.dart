import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {

  final String documentID;

  ItemList({
    Key key,
    this.documentID
    }) : super(key: key);

  @override
  _ItemListState createState() => new _ItemListState();
}
  
class _ItemListState extends State<ItemList>{

  FirebaseUser _user;
  String _documentId;
  
  @override
  void initState(){
    super.initState();
  }

  Widget createAppBar() {
    return new AppBar(
      centerTitle: true,
      title: Text("${widget.documentID}"),
    );
  }

  Widget createItem() {
    return new FloatingActionButton(
      elevation: 4.0,
      child: const Icon(Icons.create),
      onPressed: () {},
    );
  }

  Widget bottomNavigation() {
    return new BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      color: Colors.blue,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.insert_invitation),
            onPressed: () {},
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(),
      body: new Center(
        child: new FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          textColor: Theme.of(context).accentColor,
          child: new Text('Back to EventList'),
        )
      ),
      floatingActionButton: createItem(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavigation(),
    );
  }
}