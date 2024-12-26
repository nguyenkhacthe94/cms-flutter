import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8080'; // Update if needed

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/posts'));
    print('Response Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      print('Decoded JSON: $data');
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      print('Request Failed: ${response.statusCode}');
      throw Exception('Failed to fetch posts');
    }
  }

  Future<String?> login(String username, String password) async {
    final response = await http.post(Uri.parse('$_baseUrl/login'),
        body: { 'username': username, 'password': password, });

    if(response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}