import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {

  SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {

  SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class SignUpWithEmailButtonPressed extends SignUpEvent {
  SignUpWithEmailButtonPressed();
}

class SignUpLoginPressed extends SignUpEvent {
  SignUpLoginPressed();
}

