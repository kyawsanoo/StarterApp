import 'package:equatable/equatable.dart';

class NotificationEvent extends Equatable{

  @override
  List<Object?> get props => [];

}

class NotificationInitialEvent extends NotificationEvent{
  Map<String, dynamic> message;

  NotificationInitialEvent(this.message);

  @override
  List<Object?> get props => [];

}

class NotificationForegroundEvent extends NotificationEvent{
  Map<String, dynamic> message;

  NotificationForegroundEvent(this.message);

  @override
  List<Object?> get props => [message];

}

class NotificationBackgroundEvent extends NotificationEvent{
  Map<String, dynamic> message;

  NotificationBackgroundEvent(this.message);

  @override
  List<Object?> get props => [message];

}

class GetNotificationEvent extends NotificationEvent{

  GetNotificationEvent();

  @override
  List<Object?> get props => [];

}