import 'package:equatable/equatable.dart';
import 'package:starterapp/inbox/message_model.dart';

class NotificationState extends Equatable{
  int unReadCount;
  List<FirebaseMessageModel> messageList;

  NotificationState(this.messageList, this.unReadCount);

  @override
  List<Object?> get props => [messageList, unReadCount];

}

