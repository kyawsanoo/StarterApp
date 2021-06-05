import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:starterapp/authentication/blocs/blocs.dart';
import 'package:starterapp/authentication/models/error_response.dart';
import 'package:starterapp/authentication/models/user.dart';
import 'package:starterapp/authentication/repository/repository.dart';

import '../signup.dart';
import 'blocs.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationBloc authenticationBloc;
  final AuthenticationRepository authenticationRepository;

  SignUpBloc({required this.authenticationBloc,
    required this.authenticationRepository}):
        super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {

    if(event is SignUpEmailChanged){
      yield _mapSignUpEmailChangedToEvent(event, state);
    }
    else if (event is SignUpPasswordChanged) {
      yield _mapSignUpPasswordChangedToEvent(event, state);
    }
    else if (event is SignUpWithEmailButtonPressed) {
      yield* _mapSignUpWithEmailToState(event, state);
    }

    else if (event is SignUpLoginPressed){
      _mapSignUpLoginPressedToState(event, state);
    }

  }

  Stream<SignUpState> _mapSignUpWithEmailToState(
      SignUpWithEmailButtonPressed event, SignUpState state) async* {
      if (state.status.isValidated) {
          yield state.copyWith(status: FormzStatus.submissionInProgress);
          final response = await authenticationRepository.register(state.email.value, state.password.value);
          if (response is User) {
            User user = response;
            yield state.copyWith(status: FormzStatus.submissionSuccess);
            authenticationBloc.add(UserSignedUp(user: user));
          }else if(response is ErrorResponse){
            ErrorResponse exception = response;
            yield state.copyWith(status: FormzStatus.submissionFailure, errorMessage: exception.error);
          }
      }else{
        yield state.copyWith(status: FormzStatus.invalid);
      }
  }

  SignUpState _mapSignUpEmailChangedToEvent(
      SignUpEmailChanged event, SignUpState state)  {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }


  SignUpState _mapSignUpPasswordChangedToEvent(
      SignUpPasswordChanged event, SignUpState state)  {
    final password = Password.dirty(event.password);
    return state.copyWith(
        password: password,
        status: Formz.validate([password, state.email]),
    );
  }

  void _mapSignUpLoginPressedToState(SignUpLoginPressed event, SignUpState state) {
    authenticationBloc.add(SignUpPageLoginPressed());
  }
}
