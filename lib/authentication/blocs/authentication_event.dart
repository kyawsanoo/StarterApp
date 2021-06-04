import 'package:equatable/equatable.dart';
import 'package:starterapp/authentication/models/models.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoaded extends AuthenticationEvent {}

// Fired when a user has successfully logged in
class UserLoggedIn extends AuthenticationEvent {
  final User user;

  UserLoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

// Fired when a user has successfully signed up
class UserSignUp extends AuthenticationEvent {
  final User user;

  UserSignUp({required this.user});

  @override
  List<Object> get props => [user];
}

// Fired when the user has logged out
class UserLoggedOut extends AuthenticationEvent {}

// Fired when the user pressed signup
class UserSignUpClick extends AuthenticationEvent {}

// Fired when the user pressed login
class UserLoginClick extends AuthenticationEvent {}
