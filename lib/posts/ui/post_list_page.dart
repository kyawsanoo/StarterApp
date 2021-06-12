import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/authentication/blocs/blocs.dart';
import 'package:starterapp/localization/app_localizations.dart';
import 'package:starterapp/localization/localization.dart';
import 'package:starterapp/posts/navdrawer/nav_drawer_bloc.dart';
import 'package:starterapp/posts/navdrawer/nav_drawer_event.dart';
import 'package:starterapp/posts/navdrawer/nav_drawer_state.dart';
import 'package:starterapp/posts/posts.dart';
import 'post_detail_page.dart';
import 'setting_page.dart';

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
  late NavDrawerBloc _bloc;
  late Widget _content;
  
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostListCubit>(context)..fetchPostList();
    _bloc = BlocProvider.of<NavDrawerBloc>(context);
    _content = _getContentForState(_bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return
      BlocListener<NavDrawerBloc, NavDrawerState>(
            listener: (BuildContext context, NavDrawerState state) {
              setState(() {
                _content = _getContentForState(state);
              });
            },
            child: BlocBuilder<NavDrawerBloc, NavDrawerState>(
              builder: (BuildContext context, NavDrawerState state) => Scaffold(
                  drawer: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (BuildContext context, AuthenticationState authenticationState){
                      if(authenticationState is AuthenticationAuthenticated){
                        return NavDrawerWidget(authenticationState.user.name, authenticationState.user.email);
                      }else{
                        return NavDrawerWidget("unknown name", "unknown email");
                      }

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
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // do something
                          authenticationBloc.add(UserLoggedOut());
                        },
                      )
                    ],
                  ),
                  body: AnimatedSwitcher(
                    switchInCurve: Curves.easeInExpo,
                    switchOutCurve: Curves.easeOutExpo,
                    duration: Duration(milliseconds: 300),
                    child: _content,
                  ),

            ),
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
                                  return ListTile(title: Text(post.title),
                                      onTap: () =>
                                          _navigateToPostDetailPage(
                                              context, post.id.toString()));
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
            return Center(child: Text(AppLocalizations.of(context).translate("inbox")));
          }
      ) ;
    }else{
      return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            return Center(child: Text(AppLocalizations.of(context).translate("about_us")));
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

class NavDrawerWidget extends StatelessWidget {

  final String accountName;
  final String accountEmail;
  List<_NavigationItem> getListItems(BuildContext context){
    return [
    _NavigationItem(true, null, null, null),
    _NavigationItem(false, NavItem.page_one, AppLocalizations.of(context).translate("posts"), Icons.post_add_rounded),
    _NavigationItem(false, NavItem.page_two, AppLocalizations.of(context).translate("inbox"), Icons.message_rounded),
    _NavigationItem(false, NavItem.page_three, AppLocalizations.of(context).translate("about_us"), Icons.info_rounded),
  ];

  }

  NavDrawerWidget(this.accountName, this.accountEmail);

  @override
  Widget build(BuildContext context) => Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
      child: Container(
        color: Colors.white54,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: getListItems(context).length,
            itemBuilder: (BuildContext context, int index) =>
                BlocBuilder<NavDrawerBloc, NavDrawerState>(
                  builder: (BuildContext context, NavDrawerState state) =>
                      _buildItem(getListItems(context)[index], state),
                )),
      )
  );

  Widget _buildItem(_NavigationItem data, NavDrawerState state) => data.header
  // if the item is a header return the header widget
      ? _makeHeaderItem()
  // otherwise build and return the default list item
      : _makeListItem(data, state);

  Widget _makeHeaderItem() => UserAccountsDrawerHeader(
    accountName: Text(accountName, style: TextStyle(color: Colors.white)),
    accountEmail: Text(accountEmail, style: TextStyle(color: Colors.white)),
    decoration: BoxDecoration(color: Colors.blue),
    currentAccountPicture: CircleAvatar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black12,
      child: Icon(
        Icons.person,
        size: 54,
      ),
    ),
  );

  Widget _makeListItem(_NavigationItem data, NavDrawerState state) => Card(
    color: data.item == state.selectedItem
        ? Colors.black12
        : Colors.white,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
    // So we see the selected highlight
    borderOnForeground: true,
    elevation: 0,
    margin: EdgeInsets.zero,
    child: Builder(
      builder: (BuildContext context) => ListTile(
        title: Text(
          data.title!,
          style: TextStyle(
            color: data.item == state.selectedItem
                ? Colors.white
                : Colors.blueGrey,
          ),
        ),
        leading: Icon(
          data.icon,
          // if it's selected change the color
          color: data.item == state.selectedItem
              ? Colors.white
              : Colors.blueGrey,
        ),
        onTap: () => _handleItemClick(context, data.item),
      ),
    ),
  );

  void _handleItemClick(BuildContext context, NavItem? item) {
    BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(item!));
    Navigator.pop(context);
  }

}
// helper class used to represent navigation list items
class _NavigationItem {
  final bool header;
  final NavItem? item;
  final String? title;
  final IconData? icon;
  _NavigationItem(this.header, this.item, this.title, this.icon);
}