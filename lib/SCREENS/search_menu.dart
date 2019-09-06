import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shop_app/crud.dart';

import 'package:flutter/rendering.dart';


class SearchList extends StatefulWidget {

  var snapshot;
  var _menu_list;
  SearchList(this.snapshot, this._menu_list);
  @override
  State<StatefulWidget> createState() {

    return SearchListState();
  }
}

class SearchListState extends State<SearchList> {
  var queryResultSet = [];
  var tempSearchStore = [];
  var searchIndices = [];
  var tempSearchIndices = [];


  crudMedthods crudObj = new crudMedthods();
  initiateSearch(value) {
    searchIndices = [];

    for (int i in widget._menu_list.keys) {
      if (value.toLowerCase() ==
          widget._menu_list[i].toLowerCase().substring(0, value.length)) {
        searchIndices.add(i);
      }
    }
  }




@override
Widget build(BuildContext context) {
  
  return Material(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: "Search",
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
//                    icon: Icon(Icons.search)
            ),
            onChanged: (value) {
              initiateSearch(value);
              setState(() {});
            },
            onSubmitted: (value) {
              Navigator.pop(context);
              setState(() {});
            },
            autofocus: true,
          ),
          Expanded(
            child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                String a = widget.snapshot
                    .data.documents[searchIndices[index]]['name']
                    .toString();
                String b = widget.snapshot
                    .data.documents[searchIndices[index]]['category']
                    .toString();
                String c = widget.snapshot
                    .data.documents[searchIndices[index]]['cost']
                    .toString();
                bool d = widget.snapshot.data.documents[searchIndices[index]]
                ['checkbox'];
                print('1');
                return Card(
                  child: new Container(
                    padding: EdgeInsets.all(16.0),
                    child: new ListTile(
                      onTap: () {
                        updateDialog(
                            context,
                            widget.snapshot.data.documents[searchIndices[index]]
                                .documentID,
                            a,
                            c,
                            b);
                      },
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  a,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                new Text(b,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                new Text(c,
                                    style: TextStyle(fontSize: 15.0)),
                              ],
                            ),
                          ),
                          new IconButton(
                              onPressed: () {
                                widget.snapshot
                                    .data
                                    .documents[searchIndices[index]]
                                    .reference
                                    .updateData({
                                  'checkbox': !d,
                                });
                              },
                              color: d ? Colors.green : Colors.red,
                              icon: Icon(d ? Icons.done : Icons.close))
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: searchIndices.length,
            ),
          ),
        ],
      ),
    ),
  );
}
  Future<bool> updateDialog(BuildContext context, selectedDoc, String name,
      String cost, String category) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Item', style: TextStyle(fontSize: 15.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration:
                  InputDecoration(labelText: 'Item Name', hintText: name),
                  autofocus: true,
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Category', hintText: category),
                  autofocus: true,
                  onChanged: (value) {
                    category = value;
                  },
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration:
                  InputDecoration(labelText: 'Cost', hintText: cost),
                  autofocus: true,
                  onChanged: (value) {
                    cost = 'Rs. ' + value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Delete'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  crudObj.deleteData('mahavir', selectedDoc).then((result) {
                    // dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              ),
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  crudObj.updateData('mahavir', selectedDoc, {
                    'name': name,
                    'category': category,
                    'cost': cost,
                    'searchKey': name.substring(0, 1).toUpperCase(),
                  }).then((result) {
                    // dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }
}