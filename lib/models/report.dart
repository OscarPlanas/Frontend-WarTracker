class Report {
  String id;
  String owner;
  String reported;
  String date;
  String type;
  String reason;

  Report({
    required this.id,
    required this.owner,
    required this.reported,
    required this.type,
    required this.date,
    required this.reason,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        id: json['id'],
        owner: json['owner'],
        reported: json['reported'],
        type: json['type'],
        date: json['date'],
        reason: json['reason']);
  }
}
