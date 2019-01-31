import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jogo_da_velha/game.dart';

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
            width: 260,
            height: 70,
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
                child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  new Image.asset("assets/person.png", width: 32),
                  new Text(
                    " Um Jogador",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ]),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Theme.of(context).primaryColor,
                onPressed: () {}),
          ),
        ),
        Opacity(
          opacity: opacity2.value,
          child: new Container(
            width: 260.0,
            height: 70.0,
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
                child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  new Image.asset("assets/people.png", width: 32),
                  new Text(
                    " Dois Jogadores",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ]),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage()),);
                }),
          ),
        ),
        Opacity(
          opacity: opacity3.value,
          child: new Container(
            width: 260,
            height: 70,
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
                child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  new Image.asset("assets/info.png", width: 32),
                  new Text(
                    " Sobre",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ]),
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

class _AnimatedLogo extends StatelessWidget {
  _AnimatedLogo({Key key, this.controller})
      : animation = Tween(begin: 0.0, end: 100.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.easeIn,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> animation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Image.asset(
      "assets/logo.png",
      width: animation.value,
      height: animation.value,
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

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  AnimationController _controllerMenu;
  AnimationController _controllerLogo;

  @override
  void initState() {
    super.initState();

    _controllerLogo = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _controllerMenu = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _controllerLogo.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controllerMenu.forward();
      }
    });

    _controllerLogo.forward();
  }

  @override
  void dispose() {
    _controllerLogo.dispose();
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
            flex: 40,
            child: new Container(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Jogo\nda\nvelha",
                    style: TextStyle(
                      fontSize: 65,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                  new SizedBox(
                    width: 100,
                    child: _AnimatedLogo(controller: _controllerLogo.view,),
                  ),
                ],
              ),
            ),
          ),
          new Expanded(
            flex: 60,
            child: _AnimationMenu(
              controller: _controllerMenu.view,
            ),
          )
        ],
      ),
    );
  }
}
