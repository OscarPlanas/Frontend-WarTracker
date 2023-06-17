class Blog {
  //final String id;
  String id;
  String title;
  String description;
  String body_text;
  Map<String, dynamic> author;
  String date;
  //final String image;
  //final String date;

  Blog(
      {required this.id,
      required this.title,
      required this.description,
      //required this.image,
      required this.body_text,
      required this.author,
      required this.date});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        //image: json['image'],
        body_text: json['body_text'],
        author: json['author'],
        date: json['date']);
  }
}
