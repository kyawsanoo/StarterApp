import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/localization/localization.dart';
import 'package:starterapp/posts/posts.dart';


class PostDetailPage extends StatefulWidget{

  PostDetailPage({Key? key, required this.postId}) : super(key: key);

  final String postId;



  @override
  _PostDetailPageState createState() {
    return _PostDetailPageState(this.postId);
  }

}

class _PostDetailPageState extends State<PostDetailPage>{
  final String postId;

  _PostDetailPageState(this.postId);


  @override
  void initState() {
    super.initState();
    print('post id $postId');
    BlocProvider.of<PostCubit>(context)..fetchPost('$postId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("post_detail"), style: TextStyle(fontSize: 16,)),
      ),

      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if(state is LoadingState){
            return Center(child: CircularProgressIndicator(),);
          }else if(state is PostLoadedState){
            final Post post = state.post;
            return
            ListTile(title: Text(post.title, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color)),
            subtitle :Text(post.body, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color)));
          }else if(state is ErrorState){
            return Container(child: Text("$state.error"));
          }else{
            return Container(child: Text(""));
          }
        },
      ),
    );
  }

}