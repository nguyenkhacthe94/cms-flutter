import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/post.dart';
import '../widgets/post_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> _postsFuture;
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchData();
  }

  Future<List<Post>> _fetchData() async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      context.go('/login');
    }
    return _apiService.fetchPosts();
  }


  Future<void> _logout() async {
    await _secureStorage.delete(key: 'auth_token');
    context.go('/login');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts'),
        actions: <Widget>[
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PostListItem(post: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}