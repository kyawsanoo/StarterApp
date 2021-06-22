import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/authentication/authentication.dart';
import 'package:starterapp/localization/localization.dart';

import '../posts.dart';

class NavDrawerWidget extends StatelessWidget {

  final String accountName;
  final String accountEmail;
  final int unReadCount;
  final AuthenticationBloc _authenticationBloc;

  List<_NavigationItem> getListItems(BuildContext context){
    return [
      _NavigationItem(true, null, null, null),
      _NavigationItem(false, NavItem.page_one, AppLocalizations.of(context).translate("posts"), Icons.post_add_rounded),
      _NavigationItem(false, NavItem.page_two, AppLocalizations.of(context).translate("inbox"), Icons.message_rounded),
      _NavigationItem(false, NavItem.page_three, AppLocalizations.of(context).translate("about_us"), Icons.info_rounded),
    ];

  }

  NavDrawerWidget(this.accountName, this.accountEmail, this.unReadCount, this._authenticationBloc);

  @override
  Widget build(BuildContext context) => Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: getListItems(context).length,
            itemBuilder: (BuildContext context, int index) =>
                BlocBuilder<NavDrawerBloc, NavDrawerState>(
                  builder: (BuildContext context, NavDrawerState state) =>
                      _buildItem(context, getListItems(context)[index], state),
                )),
      )
  );

  Widget _buildItem(BuildContext context, _NavigationItem data, NavDrawerState state) => data.header
      ? _makeHeaderItem(context)
      : _makeListItem(context, data, state, unReadCount);

  Widget _makeHeaderItem(BuildContext context) => UserAccountsDrawerHeader(
    accountName: Text(accountName, style: TextStyle(color: Colors.white)),
    accountEmail:Text(accountEmail, style: TextStyle(color: Colors.white)),

    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
    currentAccountPicture:
    CircleAvatar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black12,
      child:Icon(
        Icons.person,
        size: 54,
      ),
    ),
    otherAccountsPictures: [
      SizedBox(height: 35,),
      Stack(children: [
        Visibility(
            visible: accountName != "Guest",
            child: IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                _authenticationBloc.add(UserLoggedOut());
              },
            )
        ),
        Visibility(
            visible: accountName == "Guest",
            child: IconButton(
              icon: Icon(
                Icons.login_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                _authenticationBloc.add(SignUpPageLoginPressed());
              },
            )
        )

      ],),

    ],
  );

  Widget _makeListItem(BuildContext context, _NavigationItem data, NavDrawerState state, int unReadCount) => Card(
    color: data.item == state.selectedItem
        ? Colors.white54
        : Theme.of(context).backgroundColor,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
    // So we see the selected highlight
    borderOnForeground: true,
    elevation: 0,
    margin: EdgeInsets.zero,
    child: Builder(
      builder: (BuildContext context) => ListTile(
        title: data.title == "Inbox"?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              data.title!,
              style: TextStyle(
                color: data.item == state.selectedItem
                    ? Theme.of(context).textTheme.bodyText1!.color
                    : Theme.of(context).textTheme.bodyText2!.color,
              ),
            ),
            Badge(
              badgeColor: Colors.red,
              position: BadgePosition(),
              badgeContent: Text(
                '${unReadCount}',
                style: TextStyle(color: Colors.white),
              ),
              child: Text(""),
            )

          ],
        )
            :
        Text(
          data.title!,
          style: TextStyle(
            color: data.item == state.selectedItem
                ? Theme.of(context).textTheme.bodyText1!.color
                : Theme.of(context).textTheme.bodyText2!.color,
          ),
        ),
        leading: Icon(
          data.icon,
          // if it's selected change the color
          color: data.item == state.selectedItem
              ? Theme.of(context).textTheme.bodyText1!.color
              : Theme.of(context).textTheme.bodyText2!.color,
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
