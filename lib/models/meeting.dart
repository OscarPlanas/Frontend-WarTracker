class Meeting {
  String id;
  String title;
  String description;
  String date;
  Map<String, dynamic> organizer;
  String location;
  int registration_fee;
  final List<dynamic> participants;
  String imageUrl;
  double lat;
  double lng;

  Meeting(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.date,
      required this.organizer,
      required this.location,
      required this.registration_fee,
      required this.participants,
      required this.lat,
      required this.lng});

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        date: json['date'],
        organizer: json['organizer'],
        location: json['location'],
        registration_fee: json['registration_fee'],
        participants: json['participants'],
        lat: json['lat'],
        lng: json['lng']);
  }
}
