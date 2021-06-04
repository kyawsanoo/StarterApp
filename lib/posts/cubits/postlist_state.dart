
part of 'postlist_cubit.dart';

abstract class PostListState extends Equatable{

}

class PostListInitialState extends PostListState{

  @override
  List<Object> get props => [];
}

class PostListLoadingState extends PostListState{

  @override
  List<Object> get props => [];
}

class PostListLoadedState extends PostListState{
  final posts;

  PostListLoadedState(this.posts);

  @override
  List<Object> get props => [posts];
}


class PostListErrorState extends PostListState{
  String error;
  PostListErrorState(this.error);
  @override
  List<Object> get props => [error];
}
