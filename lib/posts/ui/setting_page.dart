import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/authentication/blocs/blocs.dart';

class SettingPage extends StatefulWidget{

  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() {
    return _SettingPageState();
  }

}

class _SettingPageState extends State<SettingPage>{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),),

      body: Container(
        child: ListTile(
          title: Text("Log out"),
          onTap: () {
            Navigator.pop(context);

            BlocProvider.of<AuthenticationBloc>(context)
              ..add(UserLoggedOut());
          }
        ),
      ),
    );
  }

}