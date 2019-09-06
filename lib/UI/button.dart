import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Color color;
  String string;
  VoidCallback _onPressed;

  CustomButton(this.color, this.string, this._onPressed);

  @override
  Widget build(BuildContext context) {
    
    return (new RaisedButton(
      onPressed: _onPressed,
      color: this.color,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(6.0)),
      child: new Center(
          child: new Container(
              padding: new EdgeInsets.all(14.0),
              child: new Text(
                this.string,
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ))),
    ));
  }
}
