import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemPickDialog extends StatefulWidget {

  final String documentId;
  final String itemDocumentId;
  final String userId;

  ItemPickDialog({
    Key key,
    this.documentId,
    this.itemDocumentId,
    this.userId
    }) : super(key: key);

  @override
  _ItemPickDialogState createState() => new _ItemPickDialogState();
}
  
class _ItemPickDialogState extends State<ItemPickDialog>{

  String _itemName;
  int _value = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  
  @override
  void initState(){
    super.initState();
  }

  void getEventColor() async{
    final databaseReference = Firestore.instance;
    var documentReference = databaseReference.
                            collection("events").
                            document(widget.documentId).
                            collection("itemList").
                            document(widget.itemDocumentId);

    documentReference.get().then((DocumentSnapshot document) {
      setState(() {
        _itemName = document['eventColor'];
      });
    });
  }

  // same procedure as in other classes, to insert values into 
  //database under given path 
  // void addNewItemToDatabase(String itemName, int value) async {
  //   final databaseReference = Firestore.instance;

  //   await databaseReference.collection("events").
  //                           document(widget.documentId).
  //                           collection("itemList").
  //                           document().
  //                           setData({
  //                             'name' : '$itemName',
  //                             'value' : value.toInt()
  //                           });
  // }


  // checks if everything is valid and sends after that values to
  //database
  void registerItemByPress() async {
    final _formState = _formKey.currentState;
    
    if(_formState.validate()) {
      _formState.save();

      try{
        
        // addNewItemToDatabase(_itemController.text.toString(),
        //                     _value.toInt());
        
        Navigator.pop(context);

      } catch(e) {
        print(e);
      }

    }
  }

  void incrementCounter() {
    setState(() {
      _value++;  
    });
  }

  void decrementCounter() {
    if(_value != 0) {
      setState(() {
        _value--;
      });
    }
  }

  Widget createItemCounter() {
    return new Padding (
      padding: EdgeInsets.only(top: 15.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {decrementCounter();}
          ),
          Text('$_value',
              style: new TextStyle(fontSize: 30.0)),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {incrementCounter();}
          ),
        ],
      )
    );
  }

  SingleChildScrollView itemGeneratorContent() {
    return new SingleChildScrollView(
      child: new Container(
        padding: const EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
              new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(15.0),
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          createItemCounter()
                        ],
                      )
                    )
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  showItemCreatorDialog() {
    return AlertDialog(
      title: Center(child: Text('New Item')),
      content: itemGeneratorContent(),
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        FlatButton(
          onPressed:(){registerItemByPress();},
          child: Text('Create'),
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return showItemCreatorDialog();
  }
}