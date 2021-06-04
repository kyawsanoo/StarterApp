import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:starterapp/authentication/blocs/blocs.dart';
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

          try {
            final user = await authenticationRepository.register(state.email.value, state.password.value);
            if (user != null) {
              yield state.copyWith(status: FormzStatus.submissionSuccess);
              authenticationBloc.add(UserSignUp(user: user));
            } else {
              print("user is empty");
              yield state.copyWith(status: FormzStatus.submissionFailure);
            }
          } on Exception catch (_) {
            yield state.copyWith(status: FormzStatus.submissionFailure);
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
    authenticationBloc.add(UserLoginClick());
  }
}
