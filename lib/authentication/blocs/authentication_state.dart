import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:starterapp/authentication/models/models.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {
}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;

  AuthenticationAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthenticationFailure extends AuthenticationState {
  final String? message;

  AuthenticationFailure({this.message});

  @override
  List<Object> get props => [message!];
}

class RedirectToSignUpPage extends AuthenticationState {}

class RedirectToLoginPage extends AuthenticationState {}

