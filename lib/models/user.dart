class User {
  final String id;
  String name;
  String username;
  String email;
  String password;
  //final String image;
  //final String author;
  //final String date;

  User({
    required this.id,
    required this.name,
    required this.username,
    //required this.image,
    required this.email,
    required this.password,
    //required this.author,
    //required this.date
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      //image: json['image'],
      email: json['email'],
      password: json['password'],
      //author: json['author'],
      //date: json['date']
    );
  }
}
