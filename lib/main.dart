import 'package:flutter/material.dart';
import 'package:shop_app/SCREENS/main_page.dart';
import 'package:shop_app/SCREENS/sign_in.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home:new SignInPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/hp':(context)=>HomePage(),
      },
 
    );
  }
}



