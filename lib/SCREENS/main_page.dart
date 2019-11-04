import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/SCREENS/sign_in.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'package:shop_app/vars.dart';
import 'menu_list.dart';
import 'store_control.dart';
import 'orders.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _message = new FirebaseMessaging();

  static TabController tabController;
  // static final myTabbedPageKey = new GlobalKey<HomePageState>();
  ScrollController _scrollViewController;
  switchTab() {
    print(isNewOrder.value);
    if (isNewOrder.value == true && tabController.index != 0) {
      tabController.animateTo(2);
    }
    isNewOrder.value = false;
  }

  @override
  void initState() {
    super.initState();
    _message.subscribeToTopic(store);
    isNewOrder.addListener(switchTab);
    print(store);
    tabController = new TabController(
      length: 3,
      vsync: this,
    );
    _scrollViewController = new ScrollController();
    DocumentReference documentReference =
        Firestore.instance.collection("store_data").document(store);
    documentReference.get().then((onValue) {
      shop_name = onValue.data['shop_name'].toString();
      print(shop_name);
      setState(() {});
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to close the app?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: OfflineBuilder(
        child: Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.exit_to_app),
                tooltip: "Logout",
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((onValue) {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    _message.unsubscribeFromTopic(store);
                  });
                },
              ),
            ],
            backgroundColor: Colors.green,
            title: Text(shop_name),
            bottom: TabBar(controller: tabController, tabs: [
              Tab(
                icon: Icon(Icons.menu),
              ),
              Tab(
                icon: Icon(Icons.store),
              ),
              Tab(
                icon: Icon(Icons.format_list_bulleted),
              ),
            ]),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Orders(),
              StoreControlPage(),
              MenuList(),
            ],
          ),
        ),
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity, Widget child) {
          if (connectivity == ConnectivityResult.none) {
            return DefaultTabController(
              // key: myTabbedPageKey,
              length: 3,
              child: Scaffold(
                backgroundColor: Colors.grey[850],
                persistentFooterButtons: <Widget>[
                  Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: Text(
                          "Offline",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
                appBar: new AppBar(
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    new IconButton(
                      icon: new Icon(Icons.exit_to_app),
                      tooltip: "Logout",
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((onValue) {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                          _message.unsubscribeFromTopic(store);
                        });
                      },
                    ),
                  ],
                  backgroundColor: Colors.green,
                  title: Text(shop_name),
                  bottom: TabBar(tabs: [
                    Tab(
                      icon: Icon(Icons.format_list_bulleted),
                    ),
                    Tab(
                      icon: Icon(Icons.store),
                    ),
                    Tab(
                      icon: Icon(Icons.menu),
                    ),
                  ]),
                ),
                body: TabBarView(
                  children: [
                    MenuList(),
                    StoreControlPage(),
                    Orders(),
                  ],
                ),
              ),
            );
          }
          return child;
        },
      ),
    );
  }
}
