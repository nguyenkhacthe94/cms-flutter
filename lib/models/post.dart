class Post {
  final int id;
  final String title;
  final String subtitle;
  final String content;
  final String imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.imageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }
}