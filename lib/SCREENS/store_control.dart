import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop_app/UI/rating.dart';
import 'package:snaplist/size_providers.dart';
import 'package:snaplist/snaplist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:intl/intl.dart';

import 'package:shop_app/crud.dart';
import 'package:shop_app/vars.dart';

class StoreControlPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoreControlPageState();
  }
}

class StoreControlPageState extends State<StoreControlPage>
    with AutomaticKeepAliveClientMixin {
  String _opentime = "";
  crudMedthods crudObj = new crudMedthods();
  String _closetime = "";
  // String earnings = '';

  bool open = false;
  var earnDataD;
  List<double> earnData = [];
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  Future<Null> _selectTime(BuildContext context, open, time) async {
    print(time);
    TimeOfDay initTime = TimeOfDay(
        hour: num.parse(time.split(":")[0]),
        minute: num.parse(time.split(":")[1]));
    print(initTime);
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: initTime,
    );

    if (picked != null && picked != TimeOfDay.now()) {
      print(picked.toString().substring(10, 15));
      setState(() {
        if (open) {
          Firestore.instance
              .collection('store_data')
              .document(store)
              .updateData({
            'open_time': picked.toString().substring(10, 15),
          });
        } else {
          Firestore.instance
              .collection('store_data')
              .document(store)
              .updateData({
            'close_time': picked.toString().substring(10, 15),
          }).catchError((e) {
            print(e);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ht = 25;

    return new Material(
      child: new Scaffold(
          backgroundColor: Colors.white,
          body: new Container(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('store_data')
                    .document(store)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: Text("Loading..."));
                  earnData = [];
                  open = snapshot.data['open'];
                  _opentime = (snapshot.data['open_time']).toString();
                  _closetime = (snapshot.data['close_time']).toString();
                  earnings = (snapshot.data['earnings']).toString();
                  autoApprove = (snapshot.data['auto_approve']);
                  earnDataD = snapshot.data['earn_data'];
                  earnDataD.forEach((v) {
                    earnData.add(v.toDouble());
                  });
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                              onPressed: () {
                                print(open);
                                setState(() {
                                  open = !open;
                                  if (open == false) {
                                    earnData.add(double.parse(earnings));
                                  }
                                  (open) ? true : earnings = '0.0';
                                  crudObj.updateData('store_data', store, {
                                    'open': open,
                                    'earn_data': earnData,
                                    'earnings': earnings
                                  });
                                  
                                  print(earnings);
                                });
                              },
                              color: open ? Colors.lightGreen : Colors.red,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0)),
                              child: new Center(
                                child: new Container(
                                    padding: new EdgeInsets.all(10.0),
                                    child: new Text(
                                      open ? "Store Open" : "Store Closed",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 31.0,
                                      ),
                                    )),
                              )),
                          SizedBox(height: ht),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Opening Time: ",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _opentime,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        tooltip: "Edit",
                                        color: Colors.green,
                                        onPressed: () {
                                          _selectTime(context, true, _opentime);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Closing Time: ",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _closetime,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.green,
                                        tooltip: "Edit",
                                        onPressed: () {
                                          _selectTime(
                                              context, false, _closetime);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Session Earnings: ",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        " Rs." + earnings,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.green,
                                        onPressed: null,
                                        iconSize: 0,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Auto approve orders: ",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch(
                                        onChanged: (bool value) {
                                          setState(() {
                                            autoApprove = value;

                                            Firestore.instance
                                                .collection('store_data')
                                                .document(store)
                                                .updateData({
                                              'auto_approve': value,
                                            });
                                          });
                                        },
                                        activeColor: Colors.green,
                                        value: autoApprove,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Container(
                              // color: Colors.lightBlue,
                              // height: 100,

                              child: CarouselSlider(
                                items: [
                                  Card(
                                    elevation: 3,
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: new Sparkline(
                                            data: earnData,
                                            lineColor: Colors.lime,
                                            lineWidth: 3.0,
                                            pointsMode: PointsMode.all,
                                            pointSize: 10.0,
                                            pointColor: Colors.lightGreen,
                                            // fillMode: FillMode.below,
                                            // fillColor: Colors.lime,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Earnings per session",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Highest Rated Item",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ),
                                          Container(
                                            child: new Container(
                                              padding: EdgeInsets.all(4.0),
                                              child: new ListTile(
                                                title: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            new Text(
                                                              highestRatedObj[
                                                                  0],
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      25.0),
                                                            ),
                                                            new Text(
                                                                highestRatedObj[
                                                                    1],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15)),
                                                            new Text(
                                                                "Rs. " +
                                                                    highestRatedObj[
                                                                            2]
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        RatingIndicator(
                                                            highestRatedObj[3]),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Most Popular Item",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ),
                                          Container(
                                            child: new Container(
                                              padding: EdgeInsets.all(4.0),
                                              child: new ListTile(
                                                title: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            new Text(
                                                              mostPopularObj[0],
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      25.0),
                                                            ),
                                                            new Text(
                                                                mostPopularObj[
                                                                    1],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15)),
                                                            new Text(
                                                                "Rs. " +
                                                                    mostPopularObj[
                                                                            2]
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        RatingIndicator(
                                                            mostPopularObj[3]),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(mostPopularObj[4]
                                                    .toString() +
                                                "  people have bought this."),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                //TODO. uncommonet following two lines
                                autoPlay: true,
                                // autoPlayCurve: Curves.fastOutSlowIn,
                                // height: 300,
                                aspectRatio: 30 / 16,
                                // viewportFraction: 0.8
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
