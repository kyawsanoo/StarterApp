
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/notification/notification_state.dart';
import 'package:starterapp/posts/navdrawer/nav_drawer_bloc.dart';
import 'authentication/blocs/blocs.dart';
import 'authentication/repository/repository.dart';
import 'localization/localization.dart';
import 'login/login.dart';
import 'notification/notification_bloc.dart';
import 'notification/notification_event.dart';
import 'posts/cubits/cubits.dart';
import 'posts/posts.dart';
import 'signup/blocs/blocs.dart';
import 'signup/signup.dart';
import 'themes/themes.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
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
                    BlocProvider<ThemeBloc>(
                        create: (context) => ThemeBloc()
                    ),
                    BlocProvider<NotificationBloc>(
                        create: (context) {
                          return NotificationBloc()..add(NotificationEvent());
                        }
                    ),
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
                    BlocProvider<LocaleBloc>(
                        create: (context) => LocaleBloc()..add(LanguageLoadStarted())
                    ),

                    BlocProvider<NavDrawerBloc>(
                        create: (context) => NavDrawerBloc()
                    ),
                  ],
                  child: MyApp(),
              ),
    )
  );

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
     return _MyAppState();
  }

}

class _MyAppState extends State<MyApp> {

  late NotificationBloc _notificationBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is RedirectToSignUpPage) {
            return getSignUpPage();
          } else if (state is RedirectToLoginPage) {
            return getLoginPage();
          } else {
            return getHomePage();
          }
        }
    );
  }


  Widget getHomePage() {
    return BlocBuilder<LocaleBloc, LocaleState>(
        buildWhen: (previousState, currentState) =>
        previousState != currentState,
        builder: (_, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (_, themState) {
                return MaterialApp(
                  title: 'Starter App',
                  theme: themState.themeData,
                  supportedLocales: AppLocalizationsSetup
                      .supportedLocales,
                  localizationsDelegates: AppLocalizationsSetup
                      .localizationsDelegates,
                  localeResolutionCallback: AppLocalizationsSetup
                      .localeResolutionCallback,
                  // Each time a new state emitted, the app will be rebuilt with the new
                  // locale.
                  locale: localeState.locale,
                  home: MyHomePage(title: "Posts"),
                );
              }
          );
            /*BlocBuilder<NotificationBloc, NotificationState>(
                builder: (_, notificationState){
                  return
                }
            );*/

        }
    );
  }

  Widget getSignUpPage() {
    return BlocBuilder<LocaleBloc, LocaleState>(
        buildWhen: (previousState, currentState) =>
        previousState != currentState,
        builder: (_, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (_, themState) {
                return
                  MaterialApp(
                      title: 'Starter App',
                      theme: themState.themeData,
                      supportedLocales: AppLocalizationsSetup
                          .supportedLocales,
                      localizationsDelegates: AppLocalizationsSetup
                          .localizationsDelegates,
                      localeResolutionCallback: AppLocalizationsSetup
                          .localeResolutionCallback,
                      // Each time a new state emitted, the app will be rebuilt with the new
                      // locale.
                      locale: localeState.locale,
                      home: SignUpPage(title: "",)
                  );
              }
          );
        }
    );
  }

  Widget getLoginPage() {
    return BlocBuilder<LocaleBloc, LocaleState>(
        buildWhen: (previousState, currentState) =>
        previousState != currentState,
        builder: (_, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (_, themeState) {
                return MaterialApp(
                    title: 'Starter App',
                    theme: themeState.themeData,
                    supportedLocales: AppLocalizationsSetup
                        .supportedLocales,
                    localizationsDelegates: AppLocalizationsSetup
                        .localizationsDelegates,
                    localeResolutionCallback: AppLocalizationsSetup
                        .localeResolutionCallback,
                    // Each time a new state emitted, the app will be rebuilt with the new
                    // locale.
                    locale: localeState.locale,
                    home: LoginPage()
                );
              }
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);

    //when app is terminate
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("initial message ${message.data}");
        _notificationBloc.add(NotificationInitialEvent(message.data));
      }
    });

    //while app is foreground and opening, message arrives
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        print('A onMessage event was published! ${message.data}');
        _notificationBloc.add(NotificationForegroundEvent(message.data));
      }

      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = notification!.android;
      //in foreground, when message arrive and show push notification by FluterLocalNotificationPlugin
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    //when app is background and noti arrive and tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A onMessageOpenedApp event was published! ${message.data}');
      _notificationBloc.add(NotificationBackgroundEvent(message.data));
    });
  }
}


