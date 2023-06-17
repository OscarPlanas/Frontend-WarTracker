class Comments {
  String id;
  String content;
  Map<String, dynamic> owner;
  List<Map<String, dynamic>> likes;
  List<Map<String, dynamic>> dislikes;
  List<Map<String, dynamic>> replies;
  bool repliesVisible = false;
  bool liked = false;
  bool disliked = false;

  //final String image;
  //final String date;

  Comments({
    required this.id,
    required this.content,
    required this.owner,
    required this.likes,
    required this.dislikes,
    required this.replies,
    this.liked = false,
    this.disliked = false,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      content: json['title'],
      owner: json['description'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      replies: json['replies'],
    );
  }
}
