import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/authentication/authentication.dart';
import 'package:starterapp/localization/localization.dart';
import 'package:starterapp/notification/notification.dart';
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
                    //what you need for right drawer
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

  _navigateToInboxDetailPage (BuildContext context, FirebaseMessageModel message){
    print("inboxMessageDetail  $message");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InboxDetailPage(message: message)),
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
                          child: Container(
                              padding:  EdgeInsets.all(5),
                              child: ListView.builder(
                              itemCount: state.messageList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Dismissible(
                                    background: stackBehindDismiss(),
                                    key: ObjectKey(state.messageList[index]),
                                    child: Container (
                                    padding:EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    decoration: new BoxDecoration (
                                      //color: state.messageList[index].isRead==0? Theme.of(context).unselectedWidgetColor: Theme.of(context).selectedRowColor,
                                      border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor),),
                                    ),
                                    child: ListTile(
                                      leading: state.messageList[index].isRead==0? Icon(Icons.info,
                                        color: Theme.of(context).primaryColor,):Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                                      title: Text(state.messageList[index].title,
                                          style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color,
                                              fontWeight: FontWeight.bold)
                                      ),
                                      subtitle: Text(state.messageList[index]
                                          .description, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color)
                                      ),
                                      onTap: () {
                                        _notificationBloc.add(ReadNotificationEvent(state.messageList[index]));//change message from not read into read
                                        _navigateToInboxDetailPage(context, state.messageList[index]);
                                      },
                                    ),
                                  ),
                                    onDismissed: (direction) {
                                      var message = state.messageList.elementAt(index);

                                      // Show a snackbar. This snackbar could also contain "Undo" actions.
                                      final scaff = Scaffold.of(context);
                                      scaff.showSnackBar(SnackBar(
                                        backgroundColor: Colors.black,
                                        content: Text(AppLocalizations.of(context).translate("message_deleted_successfully"), style: TextStyle(color: Colors.white)),
                                        duration: Duration(seconds: 5),

                                      )
                                      );
                                      // Remove the item from the data source.
                                      deleteItem(state, index,message, direction);
                                    },
                                    confirmDismiss: (DismissDirection dismissDirection) async {
                                      switch(dismissDirection) {
                                        case DismissDirection.endToStart:
                                          return await _showConfirmationDialog(context) == true;
                                        case DismissDirection.startToEnd:
                                          return await _showConfirmationDialog(context) == true;
                                        case DismissDirection.horizontal:
                                        case DismissDirection.vertical:
                                        case DismissDirection.up:
                                        case DismissDirection.down:
                                          assert(false);
                                      }
                                      return false;
                                    },

                                );

                              }
                              )
                          ),

                      ),
                      Visibility(
                          visible: state.messageList.length == 0,
                          child: Center(child: Text(AppLocalizations.of(context).translate("any_message_received")))
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

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.orange,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  void deleteItem(NotificationState state, index, message, direction){
      state.messageList.removeAt(index);
      _notificationBloc.add(DeleteNotificationEvent(message));
  }

  /*void undoDeletion(index, item){
    setState((){
      messageList.insert(index, item);
    });
  }

  void clearAllMessages(){
    setState((){
      DatabaseHelper.instance.clearTable();
      messageList.clear();
      DatabaseHelper.instance.getUnreadCount().then((value) {
        setState(() {
          print("count: $value");
          notifier.setCount(value);
        });
      }).catchError((error) {
        print(error);
      });
    });
  }
  */

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(AppLocalizations.of(context).translate("want_delete_message"), style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('confirm_to_delete'), style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.pop(context, true); // showDialog() returns true
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('not_confirm_to_delete'), style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.pop(context, false); // showDialog() returns false
              },
            ),
          ],
        );
      },
    );
  }

  /*Future<bool?> _showDeleteAllConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(allTranslations.text("sure_to_delete_all" ), style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            FlatButton(
              child: Text(allTranslations.text('confirm_to_delete'), style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.pop(context, true);
                clearAllMessages();
              },
            ),
            FlatButton(
              child: Text(allTranslations.text('not_confirm_to_delete'), style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.pop(context, false); // showDialog() returns false
              },
            ),
          ],
        );
      },
    );
  }*/

}

