
part of 'post_cubit.dart';

abstract class PostState extends Equatable{

}

class InitialState extends PostState{

  @override
  List<Object> get props => [];
}

class LoadingState extends PostState{

  @override
  List<Object> get props => [];
}

class PostLoadedState extends PostState{
  final post;

  PostLoadedState(this.post);

  @override
  List<Object> get props => [post];
}



class ErrorState extends PostState{
  String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}
