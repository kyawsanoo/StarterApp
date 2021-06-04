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

    if (event is UserSignUp) {
      yield* _mapUserSignUpToState(event);
    }

    if(event is UserSignUpClick){
      yield* _mapUserSignUpClickToState(event);
    }

    if(event is UserLoginClick){
      yield* _mapUserLoginClickToState(event);
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

  Stream<AuthenticationState> _mapUserSignUpToState(UserSignUp event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await repository.signOut();
    yield AuthenticationNotAuthenticated();
  }

  Stream<AuthenticationState> _mapUserSignUpClickToState(UserSignUpClick event) async* {
    yield AuthenticationToSignUp();
  }

  Stream<AuthenticationState> _mapUserLoginClickToState(UserLoginClick event) async* {
    yield AuthenticationToLogin();
  }

}
