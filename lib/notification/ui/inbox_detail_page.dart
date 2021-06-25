import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/localization/localization.dart';
import 'package:starterapp/notification/models/message_model.dart';

late FirebaseMessageModel messageDetail;

class InboxDetailPage extends StatefulWidget{

  InboxDetailPage({Key? key, required FirebaseMessageModel message}) : super(key: key){
    messageDetail = message;
  }

  @override
  _InboxDetailPageState createState() {
    return _InboxDetailPageState();
  }

}

class _InboxDetailPageState extends State<InboxDetailPage>{
  
  @override
  void initState() {
    super.initState();
    print('messageDetail $messageDetail');
    //BlocProvider.of<messageDetailCubit>(context)..fetchmessageDetail('$messageId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("message_detail"), style: TextStyle(fontSize: 16,)),
      ),

      body: ListTile(
          title: Text(messageDetail.title,
                      style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color,
                      fontWeight: FontWeight.bold)
          ),
          subtitle: Text(messageDetail.description,
                      style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color)
                    ),
      )
    );
  }

}