import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/UI/button.dart';
import 'package:shop_app/crud.dart';
import 'package:shop_app/vars.dart';

import 'main_page.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  String _uid, _pw;
  var _auth;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var opacityVal = 1.0;
  bool btnEnabled = true;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getUser().then((user){
      print(user.email);
      print(shop_name);
      if(user!= null){
        store = user.email.toString().substring(0, user.email.toString().indexOf('@'));
        
        Navigator.pushNamedAndRemoveUntil(context, '/hp', (_) => false);
      }
    });
    print('here outside async');
  }
 Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
}

  @override
  Widget build(BuildContext context) {
  
    return Opacity(
      opacity: opacityVal,
      child: Scaffold(
          resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.white,
          body: Builder(
            builder: (context) {
              return Form(
                  key: _formKey,
                  child: new Padding(
                      padding: new EdgeInsets.all(40.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 0),
                            Image.asset(
                              "assets/logo_iitgn.png",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Hungry?",
                              style: TextStyle(
                                  fontSize: 30.0, fontFamily: "Quicksand"),
                            ),
                            Center(
                              child: Text(
                                "Chal yaar, kuch khate h",
                                style: TextStyle(
                                    fontSize: 16.0, fontFamily: "Quicksand"),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return "Please enter your email id";
                                }
                                if (!input.contains("@") &&
                                    !input.contains(".")) {
                                  return "Please enter a valid email id";
                                }
                              },
                              onSaved: (input) => _uid = input,
                              style: TextStyle(fontFamily: "Quicksand"),
                              decoration: InputDecoration(
                                labelText: "Email ID",
                                border: OutlineInputBorder(),
                                //                          icon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [
                                BlacklistingTextInputFormatter(
                                    new RegExp('[\\-|\\ ]'))
                              ],
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return "Please enter your password";
                                }
                              },
                              style: TextStyle(fontFamily: "Quicksand"),
                              onSaved: (input) => _pw = input,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
//                          icon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 30),
                            new RaisedButton(
                              onPressed:
                                  btnEnabled ? () => signIn(context) : null,
                              color: Colors.green,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0)),
                              child: new Center(
                                  child: new Container(
                                      padding: new EdgeInsets.all(14.0),
                                      child: new Text(
                                        "SIGN IN",
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ))),
                            ),
                            SizedBox(height: 00),
                          ],
                        ),
                      )));
            },
          )),
    );
  }

  Future<void> signIn(context) async {
    final formState = _formKey.currentState;
    //TODO remove the next few lines and uncomment the next few
// Navigator.pop(context);
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => HomePage()));
    Scaffold.of(context).hideCurrentSnackBar();
    // if(accountStatus == "Signed In"){
    //   Navigator.pushNamedAndRemoveUntil(context, '/hp', (_) => false);

    // }
    if (formState.validate()) {
      formState.save();
      setState(() {
        opacityVal = 0.5;
        btnEnabled = false;
      });

      try {
        crudMedthods crudObj = new crudMedthods();
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: Row(children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Loading...")
          ]),
        ));
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _uid, password: _pw)
            .then((onValue) {
          store = _uid.substring(0, _uid.indexOf('@'));
          print(store);
          opacityVal = 1.0;
          btnEnabled = true;
          Scaffold.of(context).hideCurrentSnackBar();
          Navigator.pushNamedAndRemoveUntil(context, '/hp', (_) => false);
        });
      } catch (e) {
        setState(() {
          opacityVal = 1.0;
          btnEnabled = true;
        });

        Scaffold.of(context).hideCurrentSnackBar();
        if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: Text("No internet connection"),
          ));
        } else {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: Text("Invalid Credentials"),
          ));
        }
        print(e.code);
      }
    }
  }
}
