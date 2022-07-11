class MeetingDetails {
  String? id;
  String? hostId;
  String? hostName;

  MeetingDetails({this.id, this.hostId, this.hostName});

  factory MeetingDetails.fromJson(Map<String, dynamic> json) {
    return MeetingDetails(
      id: json['id'] as String,
      hostId: json['hostId'] as String,
      hostName: json['hostName'] as String,
    );
  }
}
