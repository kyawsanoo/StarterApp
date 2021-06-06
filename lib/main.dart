
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/splash/splash.dart';
import 'authentication/blocs/blocs.dart';
import 'authentication/repository/repository.dart';
import 'login/login.dart';
import 'posts/cubits/cubits.dart';
import 'posts/posts.dart';
import 'signup/blocs/blocs.dart';
import 'signup/signup.dart';

void main() {

  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository(),
          ),
          RepositoryProvider<PostRepository>(
              create: (context) => PostRepository(),
          ),
        ],
        child:
              MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthenticationBloc>(
                      create: (context) {
                         AuthenticationRepository authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);
                         return AuthenticationBloc(repository: authenticationRepository)
                            ..add(AppLoaded());
                      }
                    ),
                    BlocProvider<LoginBloc>(create: (context) {
                        AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                        AuthenticationRepository authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);

                        return LoginBloc(authenticationBloc: authenticationBloc, authenticationRepository: authenticationRepository);
                      }
                    ),

                    BlocProvider<SignUpBloc>(create: (context) {
                      AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                      AuthenticationRepository authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);

                      return SignUpBloc(authenticationBloc: authenticationBloc, authenticationRepository: authenticationRepository);
                    }
                    ),

                    BlocProvider<PostListCubit>(
                      create: (context) {
                        PostRepository postRepository = RepositoryProvider.of<PostRepository>(context);
                        return PostListCubit(repository: postRepository);
                      }
                    ),
                    BlocProvider<PostCubit>(
                      create: (context) {
                        PostRepository postRepository = RepositoryProvider.of<
                            PostRepository>(context);
                        return PostCubit(repository: postRepository);
                      }
                    ),
                  ],
                  child: MyApp(),
              ),
    )
  );

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
     return _MyAppState();
  }

}

class _MyAppState extends State<MyApp>{
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          navigatorKey: _navigatorKey,
          builder: (context, child){
              return BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state){
                        if (state is AuthenticationAuthenticated) {
                          // show home page
                          _navigator.pushAndRemoveUntil<void>(
                                MyHomePage.route(),
                                    (route) => false
                          );


                        }
                        // show sign up page
                        else if(state is RedirectToSignUpPage){
                          _navigator.pushAndRemoveUntil<void>(
                              SignUpPage.route(),
                              (route) => false
                          );

                        }
                        // otherwise show login page
                        else{
                          _navigator.pushAndRemoveUntil<void>(
                              LoginPage.route(),
                                  (route) => false
                          );                        }
                     },
                     child: child,
              );
          },
          onGenerateRoute: (_) => SplashPage.route(),
      );

  }

}


