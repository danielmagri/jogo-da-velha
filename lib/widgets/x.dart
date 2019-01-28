import 'package:flutter/material.dart';

class X extends StatelessWidget {
  X({ Key key, this.size }) : super(key: key);

  double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          new RotationTransition(
            turns: new AlwaysStoppedAnimation(45 / 360),
            child: new Container(color: Color.fromARGB(255, 84, 84, 84), height: size,),
          ),
          new RotationTransition(
            turns: new AlwaysStoppedAnimation(-45 / 360),
            child: new Container(color: Color.fromARGB(255, 84, 84, 84), height: size,),
          )
        ],
      ),
    );
  }
}