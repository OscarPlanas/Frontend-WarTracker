class Blog {
  String id;
  String title;
  String description;
  String body_text;
  Map<String, dynamic> author;
  String date;
  String imageUrl;
  final List<dynamic> usersLiked;

  Blog(
      {required this.id,
      required this.title,
      required this.description,
      required this.body_text,
      required this.author,
      required this.date,
      required this.imageUrl,
      required this.usersLiked});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        body_text: json['body_text'],
        author: json['author'],
        date: json['date'],
        imageUrl: json['imageUrl'],
        usersLiked: json['usersLiked']);
  }
}
