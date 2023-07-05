class User {
  final String id;
  String name;
  String username;
  String email;
  String password;
  String imageUrl;
  String backgroundImageUrl;
  String about;
  //final String date;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.email,
    required this.password,
    required this.backgroundImageUrl,
    required this.about,
    //required this.date
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      password: json['password'],
      backgroundImageUrl: json['backgroundImageUrl'],
      about: json['about'],
      //date: json['date']
    );
  }
}
