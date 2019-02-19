import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  _launchMagrizo() async {
    const url = 'https://magrizo.wordpress.com/projetos/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  _launchGithub() async {
    const url = 'https://github.com/danielmagri/jogo-da-velha';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
                flex: 1,
                child: new Align(
                  alignment: Alignment(-1.0, 0.0),
                  child: new FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: new Row(
                      children: <Widget>[
                        new Icon(
                          Icons.chevron_left,
                          size: 60.0,
                          color: Colors.white,
                        ),
                        new Text(
                          "Voltar",
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )),
            new Expanded(
              flex: 2,
              child: Container(
                alignment: AlignmentDirectional(0.0, 0.65),
                child: new Text(
                  "Jogo da velha",
                  style: new TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            new Expanded(
                flex: 2,
                child: Center(
                  child: new Text("Feito por MAGRIZO", style: new TextStyle(fontSize: 30.0)),
                )),
            new Expanded(
              flex: 2,
              child: new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Código fonte ", style: new TextStyle(fontSize: 22.0)),
                      GestureDetector(
                          onTap: _launchGithub,
                          child: new Text("github",
                              style: new TextStyle(color: Theme.of(context).primaryColor, fontSize: 25.0))),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text("Aprenda a fazer ", style: new TextStyle(fontSize: 22.0)),
                        GestureDetector(
                            onTap: _launchMagrizo,
                            child: new Text("tutorial",
                                style: new TextStyle(color: Theme.of(context).primaryColor, fontSize: 25.0))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
