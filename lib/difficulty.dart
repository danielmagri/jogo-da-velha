import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _AnimationMenu extends StatelessWidget {
  _AnimationMenu({Key key, this.controller})
      : opacity1 = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        opacity2 = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.1,
              0.9,
              curve: Curves.ease,
            ),
          ),
        ),
        opacity3 = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.2,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity1;
  final Animation<double> opacity2;
  final Animation<double> opacity3;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Opacity(
          opacity: opacity1.value,
          child: new Container(
            width: 260.0,
            height: 75.0,
            padding: const EdgeInsets.all(12.0),
            child: new RaisedButton(
                child: new Text(
                  "Fácil",
                  style: TextStyle(fontSize: 24.0),
                ),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DifficultyPage()),
                  );
                }),
          ),
        ),
        Opacity(
          opacity: opacity2.value,
          child: new Container(
            width: 260.0,
            height: 75.0,
            padding: const EdgeInsets.all(12.0),
            child: new RaisedButton(
                child: new Text(
                  "Médio",
                  style: TextStyle(fontSize: 24.0),
                ),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Theme.of(context).primaryColor,
                onPressed: () {}),
          ),
        ),
        Opacity(
          opacity: opacity3.value,
          child: new Container(
            width: 260.0,
            height: 75.0,
            padding: const EdgeInsets.all(12.0),
            child: new RaisedButton(
                child: new Text(
                  "Impossível",
                  style: TextStyle(fontSize: 24.0),
                ),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Theme.of(context).primaryColor,
                onPressed: () {}),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class DifficultyPage extends StatefulWidget {
  @override
  _DifficultyPageState createState() => _DifficultyPageState();
}

class _DifficultyPageState extends State<DifficultyPage> with TickerProviderStateMixin {
  AnimationController _controllerMenu;

  @override
  void initState() {
    super.initState();

    _controllerMenu = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _controllerMenu.forward();
  }

  @override
  void dispose() {
    _controllerMenu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: new Column(
        children: <Widget>[
          new Expanded(
            flex: 30,
            child: new Container(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: new Text(
                "Até onde você consegue chegar?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 70,
            child: _AnimationMenu(
              controller: _controllerMenu.view,
            ),
          )
        ],
      ),
    );
  }
}
