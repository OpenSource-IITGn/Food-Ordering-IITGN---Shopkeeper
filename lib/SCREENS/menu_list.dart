import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/crud.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';
import 'package:shop_app/UI/rating.dart';
import 'package:shop_app/vars.dart';

var search = ValueNotifier(false);

class MenuList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuListState();
  }
}

class _MenuListState extends State<MenuList>
    with AutomaticKeepAliveClientMixin {
  crudMedthods crudObj = new crudMedthods();
  ScrollController _controller = ScrollController();
  var queryResultSet = [];
  var tempSearchStore = [];
  var searchIndices = [];
  var tempSearchIndices = [];
  var capitalizedValue;
  var _menu_list = new Map();
  var invMap = new Map();

  @override
  void initState() {
    super.initState();
    search.addListener(asdf);
  }

  asdf() {
    setState(() {});
  }

  initiateSearch(value) {
    invMap = _menu_list.map((k, v) => MapEntry(v, k));
    searchIndices = [];
    for (int i in _menu_list.keys) {
      if (_menu_list[i].toLowerCase().contains(value.toLowerCase())) {
        searchIndices.add(i);
      }
    }
  }

  Future<bool> updateDialog(BuildContext context, selectedDoc, String name,
      int cost, String category) async {
    return showRoundedModalBottomSheet(
        context: context,
        radius: 20.0, // This is the default
        color: Colors.white, // Also default
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('Update Item',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Item Name: ' + name,
                        icon: Icon(Icons.account_circle)),
                    autofocus: false,
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Category: ' + category,
                        icon: Icon(Icons.category)),
                    autofocus: false,
                    onChanged: (value) {
                      category = value;
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        labelText: 'Cost: Rs. ' + cost.toString(),
                        icon: Icon(Icons.attach_money)),
                    autofocus: false,
                    onChanged: (value) {
                      cost = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Delete'),
                        textColor: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).pop();
                          crudObj.deleteData(store, selectedDoc);
                        },
                      ),
                      FlatButton(
                        child: Text('Update'),
                        textColor: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).pop();
                          crudObj.updateData(store, selectedDoc, {
                            'name': name,
                            'category': category,
                            'cost': cost,
                           
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  List<double> allRatings = [];
  List<int> numOrdered = [];
  int highestRatedIndex;
  int mostPopularIndex;

  @override
  Widget build(BuildContext context) {
    if (search.value != true) {
      return Scaffold(
        body: Material(
          color: Colors.greenAccent,
          child: new HideFabOnScrollScaffold(
            controller: _controller,
            body: StreamBuilder(
                stream: Firestore.instance.collection(store).snapshots(),
                builder: (context, snapshot) {
                  allRatings = [];
                  numOrdered = [];
                  if (!snapshot.hasData)
                    return Center(child: Text("Loading..."));
                  return Scrollbar(
                    child: ListView.builder(
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        String a =
                            snapshot.data.documents[index]['name'].toString();
                        
                        String b = snapshot.data.documents[index]['category']
                            .toString();
                        int c = snapshot.data.documents[index]['cost'];
                        double rating = num.parse(snapshot
                                .data.documents[index]['actual_rating']
                                .toDouble()
                                .toStringAsPrecision(2))
                            .toDouble();
                        
                        bool d = snapshot.data.documents[index]['checkbox'];
                        
                        _menu_list[index] = a;
                        print(index);
                        if (true) {
                          // print(numOrdered);
                          // print(allRatings);
                          for(int i = 0; i<snapshot.data.documents.length;i++){
                            var nrate = snapshot.data.documents[i]['nRating'];
                            double rating1 = num.parse(snapshot
                                .data.documents[i]['actual_rating']
                                .toDouble()
                                .toStringAsPrecision(2))
                            .toDouble();
                            numOrdered.add(nrate);
                            allRatings.add(rating1);
                          }
                          mostPopularIndex =
                              numOrdered.indexOf(numOrdered.reduce(max));
                          highestRatedIndex =
                              allRatings.indexOf(allRatings.reduce(max));
                    
                          crudObj.updateData("store_data", store, {
                            'highestRatedIndex': highestRatedIndex,
                            'mostPopularIndex': mostPopularIndex
                          });
                          highestRatedObj = [
                            snapshot.data.documents[highestRatedIndex]['name']
                                .toString(),
                            snapshot
                                .data.documents[highestRatedIndex]['category']
                                .toString(),
                            snapshot.data.documents[highestRatedIndex]['cost'],
                            num.parse(snapshot
                                    .data
                                    .documents[highestRatedIndex]
                                        ['actual_rating']
                                    .toDouble()
                                    .toStringAsPrecision(2))
                                .toDouble()
                          ];
                          mostPopularObj = [
                            snapshot.data.documents[mostPopularIndex]['name']
                                .toString(),
                            snapshot
                                .data.documents[mostPopularIndex]['category']
                                .toString(),
                            snapshot.data.documents[mostPopularIndex]['cost'],
                            num.parse(snapshot
                                    .data
                                    .documents[mostPopularIndex]
                                        ['actual_rating']
                                    .toDouble()
                                    .toStringAsPrecision(2))
                                .toDouble(),
                            snapshot.data.documents[mostPopularIndex]['nRating']
                          ];
                        }

                        return Card(
                          child: new Container(
                            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                            child: new ListTile(
                              onTap: () {
                                updateDialog(
                                    context,
                                    snapshot.data.documents[index].documentID,
                                    a,
                                    c,
                                    b);
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text(" Item updated!"),
                                ));
                              },
                              title: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            a,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.0),
                                          ),
                                          new Text(b,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          new Text("Rs. " + c.toString(),
                                              style: TextStyle(fontSize: 15.0)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      RatingIndicator(rating),
                                      new IconButton(
                                          onPressed: () {
                                            snapshot
                                                .data.documents[index].reference
                                                .updateData({
                                              'checkbox': !d,
                                            });
                                          },
                                          color: d ? Colors.green : Colors.red,
                                          icon: Icon(
                                              d ? Icons.done : Icons.close))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                    ),
                  );
                }),
          ),
        ),
      );
    } else {
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
                      search.value = false;
                      setState(() {});
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
                  print(value);

                  initiateSearch(value);

                  setState(() {});
                },
                autofocus: true,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: Firestore.instance.collection(store).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: Text("Loading..."));
                      return new ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          String a = snapshot
                              .data.documents[searchIndices[index]]['name']
                              .toString();
                          String b = snapshot
                              .data.documents[searchIndices[index]]['category']
                              .toString();
                          int c = snapshot.data.documents[searchIndices[index]]
                              ['cost'];
                          bool d = snapshot.data.documents[searchIndices[index]]
                              ['checkbox'];
                          double actual_rating = num.parse(snapshot
                                  .data
                                  .documents[searchIndices[index]]
                                      ['actual_rating']
                                  .toDouble()
                                  .toStringAsPrecision(2))
                              .toDouble();
                          return Card(
                            child: new Container(
                              padding:
                                  EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                              child: new ListTile(
                                onTap: () {
                                  updateDialog(
                                      context,
                                      snapshot
                                          .data
                                          .documents[searchIndices[index]]
                                          .documentID,
                                      a,
                                      c,
                                      b);
                                },
                                title: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              a,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25.0),
                                            ),
                                            new Text(b,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            new Text("Rs. " + c.toString(),
                                                style:
                                                    TextStyle(fontSize: 15.0)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        RatingIndicator(actual_rating),
                                        new IconButton(
                                            onPressed: () {
                                              snapshot.data.documents[index]
                                                  .reference
                                                  .updateData({
                                                'checkbox': !d,
                                              });
                                            },
                                            color:
                                                d ? Colors.green : Colors.red,
                                            icon: Icon(
                                                d ? Icons.done : Icons.close))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: searchIndices.length,
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class HideFabOnScrollScaffold extends StatefulWidget {
  const HideFabOnScrollScaffold({
    Key key,
    this.body,
    this.floatingActionButton,
    this.controller,
  }) : super(key: key);

  final Widget body;
  final Widget floatingActionButton;
  final ScrollController controller;

  @override
  State<StatefulWidget> createState() => HideFabOnScrollScaffoldState();
}

class HideFabOnScrollScaffoldState extends State<HideFabOnScrollScaffold> {
  bool _fabVisible = true;

  Future<String> _addField(BuildContext context) async {
    String itemName = '';
    String category = '';
    int cost;
    return showRoundedModalBottomSheet(
        context: context,
        radius: 20.0, // This is the default
        color: Colors.white, // Also default
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('Add Item',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Item Name',
                        icon: Icon(Icons.account_circle)),
                    autofocus: false,
                    onChanged: (value) {
                      itemName = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Category', icon: Icon(Icons.category)),
                    autofocus: false,
                    onChanged: (value) {
                      category = value;
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        labelText: 'Cost', icon: Icon(Icons.attach_money)),
                    autofocus: false,
                    onChanged: (value) {
                      cost = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          if (itemName != '' &&
                              category != '' &&
                              cost != null) {
                            didAdd = true;
                            Firestore.instance
                                .runTransaction((transaction) async {
                              await transaction.set(
                                  Firestore.instance
                                      .collection(store)
                                      .document(),
                                  {
                                    'name': itemName,
                                    'cost': cost,
                                    'category': category,
                                    'checkbox': true,
                                    'actual_rating': 0,
                                    'rating': 0,
                                    'nRating': 0,
                                  });
                            });
                          }
                          Navigator.of(context).pop(itemName);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateFabVisible);
    widget.controller.addListener(_listEnd);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateFabVisible);
    widget.controller.removeListener(_listEnd);
    super.dispose();
  }

  void _listEnd() {}

  void _updateFabVisible() {
    final newFabVisible = (widget.controller.position.userScrollDirection ==
            ScrollDirection.forward)
        ? true
        : false;
    if (_fabVisible != newFabVisible) {
      setState(() {
        _fabVisible = newFabVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
      resizeToAvoidBottomPadding: true,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: _fabVisible,
        curve: Curves.easeInCubic,
        overlayColor: Colors.blueGrey,
        overlayOpacity: 0.3,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.lightGreen,
              label: 'New Item',
              onTap: () {
                _addField(context).then((asdf) {
                  if (didAdd) {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(" Item added to the menu!"),
                    ));
                    didAdd = false;
                  }
                });
              }),
          SpeedDialChild(
            child: Icon(Icons.search),
            backgroundColor: Colors.lightGreen,
            label: 'Search',
            onTap: () {
              search.value = true;
            },
          ),
        ],
      ),
    );
  }
}
