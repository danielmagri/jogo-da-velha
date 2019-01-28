import 'package:flutter/material.dart';

class O extends StatelessWidget {
  O({Key key, this.size}) : super(key: key);

  double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
        margin: EdgeInsets.all(6.0),
        child: new Container(
          margin: EdgeInsets.all(size),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).backgroundColor,
          ),
        ),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
