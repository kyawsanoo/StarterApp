import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/authentication/blocs/blocs.dart';
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostListCubit>(context)..fetchPostList();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          actions: <Widget>[
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
        body:
        BlocBuilder<PostListCubit, PostListState>(
            builder: (context, state)
            {
              if(state is PostListLoadingState){
                return Center(child: CircularProgressIndicator());
              }
              else if(state is PostListLoadedState){
                List<Post> postList = state.posts;
                return Center(
                    child: ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          Post post = postList[index];
                          print("post ${post.toString()}");
                          return ListTile(title: Text(post.title),
                              onTap:() => _navigateToPostDetailPage(context, post.id.toString()));

                        }
                    ));
              }
              else {
                return Container();
              }
            }
        )
    );

  }

  _navigateToPostDetailPage (BuildContext context, String id){
    print("post id $id");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailPage(postId: '$id')),
    );
  }

  _navigateToSettingPage (BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }
}

