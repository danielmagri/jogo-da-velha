import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:jogo_da_velha/menu.dart';

void main() => runApp(MagrizoApp());

class MagrizoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da velha',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 13, 161, 146),
        backgroundColor: Color.fromARGB(255, 20, 189, 172),
        brightness: Brightness.dark,
        fontFamily: 'Engcomica',
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{'/MenuPage': (BuildContext context) => new MenuPage()},
    );
  }
}

class _AnimatedLogo extends AnimatedWidget {
  _AnimatedLogo({Key key, Animation<double> animation}) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: new Image.asset(
        "assets/logo.png",
        width: animation.value,
        height: animation.value,
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  void navigationToNextPage() {
    Navigator.pushReplacementNamed(context, '/MenuPage');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 100.0, end: 0.0).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        navigationToNextPage();
      }
    });

    var _duration = new Duration(seconds: 2);
    new Timer(_duration, () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _AnimatedLogo(animation: _animation),
    );
  }
}
