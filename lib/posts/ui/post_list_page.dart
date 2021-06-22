import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/authentication/authentication.dart';
import 'package:starterapp/localization/localization.dart';
import 'package:starterapp/notification/notification_bloc.dart';
import 'package:starterapp/notification/notification_event.dart';
import 'package:starterapp/notification/notification_state.dart';
import 'package:starterapp/posts/posts.dart';
import 'package:starterapp/themes/themes.dart';
import 'drawer.dart';
import 'post_detail_page.dart';
late AuthenticationBloc _authenticationBloc;

class MyHomePage extends StatefulWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MyHomePage(title: "Posts"));
  }

  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late NavDrawerBloc _navDrawerBloc;
  late ThemeBloc _themeBloc;
  late Widget _content;
  late bool _isDarkTheme;
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<PostListCubit>(context)..fetchPostList();
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    _isDarkTheme = _themeBloc.state.themeData == AppThemes.appThemeData[AppTheme.darkTheme];
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _navDrawerBloc = BlocProvider.of<NavDrawerBloc>(context);
    _content = _getContentForState(_navDrawerBloc.state);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return
      BlocListener<NavDrawerBloc, NavDrawerState>(
            listener: (BuildContext context, NavDrawerState state) {
              setState(() {
                _content = _getContentForState(state);
              });
            },
            child: BlocBuilder<NavDrawerBloc, NavDrawerState>(
              builder: (BuildContext context, NavDrawerState state) {

                return Scaffold(
                  onDrawerChanged: (isOpened) {
                    _notificationBloc.add(GetNotificationEvent());
                  },
                  onEndDrawerChanged: (isOpened) {
                    //todo what you need for right drawer
                  },
                  drawer: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (BuildContext context, NotificationState notficationState ){
                      return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (BuildContext context, AuthenticationState authenticationState){
                          if(authenticationState is AuthenticationAuthenticated){
                            return NavDrawerWidget(authenticationState.user.name, authenticationState.user.email, notficationState.unReadCount, _authenticationBloc);
                          }else{
                            return NavDrawerWidget("Guest", "guest@mail.com", notficationState.unReadCount, _authenticationBloc);
                          }

                        },
                      );
                    },
                  ),
                  appBar: AppBar(
                    title: Text(_getTextForItem(state.selectedItem), style: TextStyle(fontSize: 16,)),
                    actions: <Widget>[
                      IconButton(
                        icon: Image.asset(AppLocalizations.of(context).isEnLocale? "assets/images/language.png" : "assets/images/myanmar_lan.png",  width: 20, height: 20,),
                        onPressed: () async {
                          context.read<LocaleBloc>().add(ToggleLanguage(newLanguage: AppLocalizations.of(context).isEnLocale? 'my' : 'en'));
                        },
                      ),
                      Switch(
                        value: _isDarkTheme,
                        onChanged: (value) {
                          _isDarkTheme = value;
                          print("isDarkTheme $_isDarkTheme");
                          _themeBloc.add(ToggleTheme(_isDarkTheme? AppTheme.darkTheme : AppTheme.lightTheme));
                        },
                        activeTrackColor: Theme.of(context).textTheme.bodyText1!.color,
                        activeColor: Theme.of(context).primaryColorDark,
                      )
                    ],
                  ),
                  body: AnimatedSwitcher(
                    switchInCurve: Curves.easeInExpo,
                    switchOutCurve: Curves.easeOutExpo,
                    duration: Duration(milliseconds: 300),
                    child: _content,
                  ),

                );
              }

          ));
  }

  _navigateToPostDetailPage (BuildContext context, String id){
    print("post id $id");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailPage(postId: '$id')),
    );
  }

  Widget _getContentForState(NavDrawerState state){
    if(state.selectedItem == NavItem.page_one) {
      return
        BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
                return   BlocBuilder<PostListCubit, PostListState>(
                    builder: (context, state) {
                      if (state is PostListLoadingState) {
                        return Center(child: CircularProgressIndicator());
                      }
                      else if (state is PostListLoadedState) {
                        List<Post> postList = state.posts;
                        return Center(
                            child: ListView.builder(
                                itemCount: postList.length,
                                itemBuilder: (context, index) {
                                  Post post = postList[index];
                                  print("post ${post.toString()}");
                                  return ListTile(title: Text(post.title,
                                      style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color)
                                                          ),
                                                  onTap: () =>
                                                      _navigateToPostDetailPage(context, post.id.toString())
                                  );
                                }
                            ));
                      }
                      else {
                        return Container();
                      }
                    }
                );
            }
        ) ;

    }else if(state.selectedItem == NavItem.page_two){
      return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            return BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state){
                  if(state.messageList.length>0) {
                    print('message list greater than 0');
                    print('message list ${state.messageList.toList().toString()}');

                  }else{
                    print('message list not greater than 0');
                  }
                  return Stack(
                    children: [
                      Visibility(
                          visible: state.messageList.length>0,
                          child: ListView.builder(
                              itemCount: state.messageList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(state.messageList[index].title),
                                  subtitle: Text(state.messageList[index]
                                      .description),
                                );
                              }
                          )
                      ),
                      Visibility(
                          visible: state.messageList.length == 0,
                          child: Center(child: Text("You have not yet any message"))
                      )

                    ],
                  );

                }
            );

          }
      ) ;
    }else{
      return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            return Center(child: Text(AppLocalizations.of(context).translate("about_us"),
                style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color)
            )
            );
          }
      ) ;
    }
  }

  String _getTextForItem(NavItem navItem){
    switch(navItem){
      case NavItem.page_one :
        return AppLocalizations.of(context).translate("posts");
      case NavItem.page_two :
        return AppLocalizations.of(context).translate("inbox");
      case NavItem.page_three :
        return AppLocalizations.of(context).translate("about_us");
      default:
        return AppLocalizations.of(context).translate("posts");
    }

  }

}

