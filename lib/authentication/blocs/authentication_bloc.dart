import 'package:bloc/bloc.dart';
import 'package:starterapp/authentication/repository/repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository repository;

  AuthenticationBloc({required this.repository}):
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }

    if (event is UserSignedUp) {
      yield* _mapUserSignedUpToState(event);
    }

    if(event is LoginPageSignUpPressed){
      yield* _mapLoginPageSignUpPressedToState(event);
    }

    if(event is SignUpPageLoginPressed){
      yield* _mapSignUpPageLoginPressedToState(event);
    }

    if(event is ExceptionOccur){
      yield* _mapExceptionOccuredToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading();
    try {
      final currentUser = await repository.getCurrentUser();

      if (currentUser!= null) {
        yield AuthenticationAuthenticated(user: currentUser);
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(message:  'An unknown error occurred');
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserSignedUpToState(UserSignedUp event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await repository.signOut();
    yield AuthenticationNotAuthenticated();
  }

  Stream<AuthenticationState> _mapLoginPageSignUpPressedToState(LoginPageSignUpPressed event) async* {
    yield RedirectToSignUpPage();
  }

  Stream<AuthenticationState> _mapSignUpPageLoginPressedToState(SignUpPageLoginPressed event) async* {
    yield RedirectToLoginPage();
  }

  Stream<AuthenticationState> _mapExceptionOccuredToState(ExceptionOccur event) async* {
    yield AuthenticationException(event.exception);
  }

}
