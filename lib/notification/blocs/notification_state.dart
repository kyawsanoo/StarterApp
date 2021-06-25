import 'package:equatable/equatable.dart';

import '../notification.dart';

class NotificationState extends Equatable{
  int unReadCount;
  List<FirebaseMessageModel> messageList;

  NotificationState(this.messageList, this.unReadCount);

  @override
  List<Object?> get props => [messageList, unReadCount];

}

