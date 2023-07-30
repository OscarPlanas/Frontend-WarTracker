class User {
  final String id;
  String name;
  String username;
  String email;
  String date;
  String password;
  String imageUrl;
  String backgroundImageUrl;
  String about;
  List<dynamic> meetingsFollowed;
  List<dynamic> followers;
  List<dynamic> following;
  //final String date;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.email,
    required this.date,
    required this.password,
    required this.backgroundImageUrl,
    required this.about,
    required this.meetingsFollowed,
    required this.followers,
    required this.following,

    //required this.date
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      username: json['username'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      date: json['date'],
      password: json['password'],
      backgroundImageUrl: json['backgroundImageUrl'],
      about: json['about'],
      meetingsFollowed: json['meetingsFollowed'],
      followers: json['followers'],
      following: json['following'],
      //date: json['date']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'backgroundImageUrl': backgroundImageUrl,
      'about': about,
      'meetingsFollowed': meetingsFollowed,
      'followers': followers,
      'following': following,

      // add other properties as needed
    };
  }
}
