import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  _SplashState createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashPage>{


  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }

  @override
  void initState() {

  }
}