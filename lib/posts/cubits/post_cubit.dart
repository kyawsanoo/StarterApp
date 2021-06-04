import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterapp/posts/posts.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState>{

  final PostRepository repository;

  PostCubit({required this.repository}) : super(InitialState());

  void fetchPost(String id) async {
    try {
      emit(LoadingState());
      final post = await this.repository.getPost(id);
      emit(PostLoadedState(post));
    }catch(e){
      emit(ErrorState(e.toString()));
    }
  }
}

