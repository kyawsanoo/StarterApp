import 'package:equatable/equatable.dart';

import '../notification.dart';

class NotificationEvent extends Equatable{

  @override
  List<Object?> get props => [];

}

//Get notification event when app is killed
class NotificationInitialEvent extends NotificationEvent{
  Map<String, dynamic> message;

  NotificationInitialEvent(this.message);

  @override
  List<Object?> get props => [];

}

//trigger notification event when app is foreground
class NotificationForegroundEvent extends NotificationEvent{
  Map<String, dynamic> message;

  NotificationForegroundEvent(this.message);

  @override
  List<Object?> get props => [message];

}

//trigger notification event when app is background
class NotificationBackgroundEvent extends NotificationEvent{
  Map<String, dynamic> message;

  NotificationBackgroundEvent(this.message);

  @override
  List<Object?> get props => [message];

}

//trigger unread message event when slider drawer is open
class GetNotificationEvent extends NotificationEvent{

  GetNotificationEvent();

  @override
  List<Object?> get props => [];

}

//trigger change message from unRead to Read event when inbox item click
class ReadNotificationEvent extends NotificationEvent{
  FirebaseMessageModel message;

  ReadNotificationEvent(this.message);

  @override
  List<Object?> get props => [message];

}

//trigger delete message inbox item drag remove click
class DeleteNotificationEvent extends NotificationEvent{
  FirebaseMessageModel message;

  DeleteNotificationEvent(this.message);

  @override
  List<Object?> get props => [message];

}