import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/notification/blocs/notification_event.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../notification.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState>{
  List<FirebaseMessageModel> messageList = <FirebaseMessageModel>[];


  NotificationBloc() : super(NotificationState(<FirebaseMessageModel>[], 0));

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if(event is NotificationForegroundEvent){
      convertFormattedMessageAndSave(event.message);
    }else if(event is NotificationBackgroundEvent){
      convertFormattedMessageAndSave(event.message);
    }else if(event is NotificationInitialEvent){
      convertFormattedMessageAndSave(event.message);
    }else if(event is GetNotificationEvent){
      print('getting message from database');
    }else if(event is ReadNotificationEvent){
      await DatabaseHelper.instance.updateIsRead(event.message);
    }else if(event is DeleteNotificationEvent){
      await DatabaseHelper.instance.delete(event.message);
    }
    List<FirebaseMessageModel> messages = await DatabaseHelper.instance.getAllMessages();
    int? unReadCount = await DatabaseHelper.instance.getUnreadCount();
    yield NotificationState(messages, unReadCount!);
  }

  void convertFormattedMessageAndSave(Map<String, dynamic> message) {
    print('saving message to database');

    var uuid = Uuid();
    // Generate a v4 (crypto-random) id
    var v4_crypto = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});

    print("message   $message");
    print("uuidv4:  $v4_crypto");
    print("title   ${message['title']}");
    print("desc   ${message['description']}");
    print("otp   ${message['otp'].toString()}");
    print("image ${message['image']}");
    print("promotion page url ${message['promotionPageUrl']}" );
    FirebaseMessageModel notiMessage = FirebaseMessageModel(uuid: v4_crypto,
        title: message['title'],
        description: message['description'] + " " +  message['description2'],
        isRead: 0,
        otp: message['otp'].toString(),
        image: message['image'],
        promotionPageUrl: message['promotionPageUrl'],
    );
    _addToDb(notiMessage);
  }

  void _addToDb(FirebaseMessageModel message) async {
    print("uuid: " + message.uuid);
    await DatabaseHelper.instance.insert(message);
  }


}