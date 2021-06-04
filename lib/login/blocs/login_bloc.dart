import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:starterapp/authentication/blocs/blocs.dart';
import 'package:starterapp/authentication/repository/repository.dart';
import 'package:starterapp/login/models/models.dart';
import 'blocs.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  final AuthenticationRepository authenticationRepository;

  LoginBloc({required this.authenticationBloc,
    required this.authenticationRepository}):
        super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

    if(event is LoginEmailChanged){
      yield _mapLoginEmailChangedToEvent(event, state);
    }
    else if (event is LoginPasswordChanged) {
      yield _mapLoginPasswordChangedToEvent(event, state);
    }
    else if (event is LoginInWithEmailButtonPressed) {
      yield* _mapLoginWithEmailToState(event, state);
    }
    else if(event is SignUpButtonPressed){
       _mapSignUpButtonClickToState(event, state);
    }

  }

  Stream<LoginState> _mapLoginWithEmailToState(
      LoginInWithEmailButtonPressed event, LoginState state) async* {
      if (state.status.isValidated) {
          yield state.copyWith(status: FormzStatus.submissionInProgress);

          try {
            final user = await authenticationRepository.login(state.email.value, state.password.value);
            if (user != null) {
              yield state.copyWith(status: FormzStatus.submissionSuccess);
              authenticationBloc.add(UserLoggedIn(user: user));
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

  LoginState _mapLoginEmailChangedToEvent(
      LoginEmailChanged event, LoginState state)  {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }


  LoginState _mapLoginPasswordChangedToEvent(
      LoginPasswordChanged event, LoginState state)  {
    final password = Password.dirty(event.password);
    return state.copyWith(
        password: password,
        status: Formz.validate([password, state.email]),
    );
  }


  void _mapSignUpButtonClickToState(SignUpButtonPressed event, LoginState state) {
    authenticationBloc.add(UserSignUpClick());
  }
}
