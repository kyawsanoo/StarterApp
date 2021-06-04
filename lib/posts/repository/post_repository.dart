
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:starterapp/posts/posts.dart';

abstract class PostAPIService {
  //set up http get post list
  Future<List<Post>> getPosts();

  //set up http get post by id
  Future<Post> getPost(String id);

  // set up http post to create new post
  Future<Post> createPost();

  // set up http put to update if exit or create post
  Future<Post> updatePost();

  // set up http patch to update post
  Future<Post> updatePost2();

  //set upp http to delete post
  deletePost();
}

class PostRepository extends PostAPIService{
  static const String baseUrl = "https://jsonplaceholder.typicode.com/posts";
  final uri = Uri.parse(baseUrl);
  Map<String, String> headers = {"Content-type": "application/json",
    "charset":"UTF-8"};

  @override
  Future<List<Post>> getPosts() async {
    try {
      Response response = await http.get(uri, headers: headers);
      final list = jsonDecode(response.body);
      final postList = list.map<Post>((val) => Post.fromJson(val)).toList();
      print('posts: ${postList.length}.');
      return postList;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Post> getPost(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    try {
      Response response = await http.get(uri, headers: headers);
      final post = Post.fromJson(jsonDecode(response.body));
      return post;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Post> createPost() async {
    final url = Uri.parse(baseUrl);
    String json = '{"title": "Hello", "body": "body text", "userId": 1}';
    try {
      // make POST request
      Response response = await http.post(url, headers: headers, body: json);
      final post = Post.fromJson(jsonDecode(response.body));
      print("post ${post.toString()}");
      return post;
    }catch(e){
      print("exception $e");
      throw e;
    }
  }

  @override
  Future<Post> updatePost() async{
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    Map<String, String> headers = {"Content-type": "application/json",
      "charset":"UTF-8"};
    String json = '{"title": "Hello", "body": "body text", "userId": 1}';
    try {
      Response response = await http.put(url, headers: headers, body: json);
      final post = Post.fromJson(jsonDecode(response.body));
      print("post ${post.toString()}");
      return post;
    }catch(e){
      print("exception $e");
      throw e;
    }
  }

  @override
  Future<Post> updatePost2() async{
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    String json = '{"title": "Hello", "body": "body text"}';
    try {
      Response response = await http.patch(url, headers: headers, body: json);
      final post = Post.fromJson(jsonDecode(response.body));
      return post;
    }catch(e){
      throw e;
    }
  }

  @override
  deletePost() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    Response response = await delete(url);
    int statusCode = response.statusCode;
  }


}
