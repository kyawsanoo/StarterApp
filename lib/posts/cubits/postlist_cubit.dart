import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/posts/posts.dart';

part 'postlist_state.dart';

class PostListCubit extends Cubit<PostListState>{

  final PostRepository repository;

  PostListCubit({required this.repository}) : super(PostListInitialState());

  void fetchPostList() async {
    try {
      emit(PostListLoadingState());
      final posts = await this.repository.getPosts();
      emit(PostListLoadedState(posts));
    }catch(e){
      emit(PostListErrorState(e.toString()));
    }
  }

}