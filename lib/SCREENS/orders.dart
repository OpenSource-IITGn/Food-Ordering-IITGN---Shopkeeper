import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shop_app/SCREENS/main_page.dart';
import 'package:shop_app/crud.dart';
import 'package:shop_app/vars.dart';

var statusMap = {
  " Rejected ": 0,
  "Approve Order": 1,
  "Waiting for payment": 2,
  "Confirm order prepared": 3,
  "Confirm order collected": 4,
  "Collected": 5,
};

var status = [
  " Rejected ",
  "Approve Order",
  "Waiting for payment",
  "Confirm order prepared",
  "Confirm order collected",
  "Collected"
];

class Orders extends StatefulWidget {
  final Widget child;

  Orders({Key key, this.child}) : super(key: key);

  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with AutomaticKeepAliveClientMixin {
  crudMedthods crudObj = new crudMedthods();

  var currentVal;
  Future<bool> approveDialog(
      BuildContext context, var doc, var currentOrderStatus,
      {bool reject: false}) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: Text('Confirm', style: TextStyle(fontSize: 20.0)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Are you sure? This cannot be reversed.",
                          style: TextStyle(fontSize: 15.0))
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Yes'),
                      textColor: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (reject != true) {
                          crudObj.updateData('orders', doc, {
                            'status': statusMap[status[currentOrderStatus + 1]],
                          });
                        } else {
                          crudObj.updateData('orders', doc, {
                            'status': statusMap[status[0]],
                          });
                        }
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      textColor: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<bool> updateDialog(
      BuildContext context,
      selectedDoc,
      var cost,
      var items,
      var otp,
      var currentOrderStatus,
      String time,
      String date,
      var note) async {
    List<Widget> itemsList = [];
    items.forEach((k, v) {
      print(k);
      print(v);
      var a = new Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  k.toString(),
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  v.toString(),
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
              ],
            ),
          ),
        ),
      );
      print(a.toString());
      itemsList.add(a);
    });
    showRoundedModalBottomSheet(
        context: context,
        radius: 20.0, // This is the default
        color: Colors.white, // Also default
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 10, 32, 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Center(
                        child: Text('Order Details',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold))),
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Order ID: ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                otp.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Cost: ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                "Rs. " + cost.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Time: ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Date: ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // ConstrainedBox(
                      //   child: ListView(
                      //     children: itemList,
                      //   ),
                      //   constraints: BoxConstraints(
                      //       maxHeight: 150, maxWidth: 120, minHeight: 10),
                      // ),
                      Column(
                        children: <Widget>[
                          Text("Ordered Items",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                              width: 150,
                              height: 125,
                              child: ListView(
                                children: itemsList,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: ButtonTheme(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(6.0)),
                          child: new FlatButton(
                            padding: const EdgeInsets.all(10.0),
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            color: (currentOrderStatus == 2 ||
                                    currentOrderStatus == 5 ||
                                    currentOrderStatus == 0)
                                ? Colors.grey
                                : Colors.green,
                            onPressed: (currentOrderStatus == 2 ||
                                    currentOrderStatus == 5 ||
                                    currentOrderStatus == 0)
                                ? null
                                : () {
                                    approveDialog(
                                      context,
                                      selectedDoc,
                                      currentOrderStatus,
                                    ).then((onValue) {
                                      Navigator.of(context).pop();
                                    });
                                  },
                            child: new Text(
                              status[currentOrderStatus],
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (currentOrderStatus == 1) ? 10 : 0,
                      ),
                      (currentOrderStatus == 1)
                          ? Flexible(
                              child: ButtonTheme(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(6.0)),
                                child: new FlatButton(
                                  padding: const EdgeInsets.all(8.0),
                                  textColor: Colors.white,
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    approveDialog(context, selectedDoc,
                                            currentOrderStatus,
                                            reject: true)
                                        .then((onValue) {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: new Text(
                                    " Reject Order  ",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                  (note != null)
                      ? Text("Note: " + note)
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('orders')
            .where('shop_username', isEqualTo: store)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          
          
          if (!snapshot.hasData) return Center(child: Text("Loading..."));
          return Scrollbar(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int s) {
                int index = snapshot.data.documents.length - s - 1;
                print('order' + index.toString());
                if(index == snapshot.data.documents.length - 1){
                  isNewOrder.value = true;
                  print(isNewOrder.value);
                }
                var cost = snapshot.data.documents[index]['bill'];
                var items = snapshot.data.documents[index]['items'];
                var otp = snapshot.data.documents[index]['unique_no'];
                var currentOrderStatus =
                    snapshot.data.documents[index]['status'];
                var orderTime = snapshot.data.documents[index]['time'];
                var orderDate = snapshot.data.documents[index]['date'];
                var note = snapshot.data.documents[index]['notes'];
                var docID = snapshot.data.documents[index].documentID;
                if (currentOrderStatus == 1 && autoApprove == true) {
                  updateDialog(context, docID, cost, items, otp,
                      currentOrderStatus, orderTime, orderDate, note);
                  crudObj.updateData('orders', docID, {
                    'status': statusMap[status[currentOrderStatus + 1]],
                  });
                }
                // HomePageState.myTabbedPageKey.currentState.tabController.animateTo(0);

                List<Widget> itemList = [];

                items.forEach((k, v) {
                  itemList.add((Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            k + ":",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(v.toString(),
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0)),
                      ],
                    ),
                  )));
                });

                return Card(
                  child: new Container(
                    padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                    child: new ListTile(
                      onTap: () {
                        updateDialog(context, docID, cost, items, otp,
                            currentOrderStatus, orderTime, orderDate, note);
                      },
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "Order " + otp.toString(),
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                new Text("Rs. " + cost.toString(),
                                    style: TextStyle(fontSize: 15.0)),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Flexible(
                                      child: ButtonTheme(
                                        minWidth: 20.0,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(6.0)),
                                        child: new FlatButton(
                                          padding: const EdgeInsets.all(8.0),
                                          textColor: Colors.white,
                                          disabledColor: Colors.grey,
                                          disabledTextColor: Colors.white,
                                          color: (currentOrderStatus == 2 ||
                                                  currentOrderStatus == 5 ||
                                                  currentOrderStatus == 0)
                                              ? Colors.grey
                                              : Colors.green,
                                          onPressed: (currentOrderStatus == 2 ||
                                                      currentOrderStatus ==
                                                          5) ||
                                                  currentOrderStatus == 0
                                              ? null
                                              : () {
                                                  approveDialog(context, docID,
                                                      currentOrderStatus);
                                                },
                                          child: new Text(
                                            status[currentOrderStatus],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: (currentOrderStatus == 1) ? 10 : 0,
                                    ),
                                    (currentOrderStatus == 1)
                                        ? Flexible(
                                            child: ButtonTheme(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          6.0)),
                                              child: new FlatButton(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                textColor: Colors.white,
                                                color: Colors.redAccent,
                                                onPressed: () {
                                                  approveDialog(context, docID,
                                                      currentOrderStatus,
                                                      reject: true);
                                                },
                                                child: new Text(
                                                  " Reject Order  ",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            width: 0,
                                            height: 0,
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: itemList,
                            ),
                          )
                        ],
                      ),
                      subtitle: (note != null)
                          ? Text("Note: " + note)
                          : SizedBox(
                              height: 0,
                            ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.documents.length,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyDialog extends StatefulWidget {
  MyDialog(this.onValueChange, this.currentVal, this.selectedDoc, this.crudObj,
      this.items, this.otp, this.cost, this.time, this.date);
  var currentVal;
  var selectedDoc;
  var crudObj;
  var items;
  var cost;
  var otp;
  List<Widget> itemsList = [];
  String time;
  String date;

  final void Function(String) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  int cval;
  crudMedthods crudObj = new crudMedthods();
  @override
  void initState() {
    super.initState();
  }

  Future<bool> approveDialog(
      BuildContext context, var doc, var currentOrderStatus,
      {bool reject: false}) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: Text('Confirm', style: TextStyle(fontSize: 20.0)),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Are you sure? This cannot be reversed.",
                            style: TextStyle(fontSize: 15.0))
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Yes'),
                      textColor: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (reject != true) {
                          crudObj.updateData('orders', doc, {
                            'status': statusMap[status[currentOrderStatus + 1]],
                          });
                        } else {
                          crudObj.updateData('orders', doc, {
                            'status': statusMap[status[0]],
                          });
                        }
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      textColor: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    print(widget.items);

    print(widget.itemsList);
  }
}
