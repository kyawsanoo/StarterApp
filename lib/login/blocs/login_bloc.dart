import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:starterapp/authentication/blocs/blocs.dart';
import 'package:starterapp/authentication/models/error_response.dart';
import 'package:starterapp/authentication/models/models.dart';
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
          final response = await authenticationRepository.login(state.email.value, state.password.value);
          if (response is User) {
            User user = response;
            yield state.copyWith(status: FormzStatus.submissionSuccess);
            authenticationBloc.add(UserLoggedIn(user: user));
          }else{
            ErrorResponse errorResponse = response;
            yield state.copyWith(status: FormzStatus.submissionFailure, errorMessage: errorResponse.error);
            authenticationBloc.add(ExceptionOccur(errorResponse.error));
          }
      }else{
        yield state.copyWith(status: FormzStatus.invalid);
        authenticationBloc.add(ExceptionOccur());
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
    authenticationBloc.add(LoginPageSignUpPressed());
  }
}
