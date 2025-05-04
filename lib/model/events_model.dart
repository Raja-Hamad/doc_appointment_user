class EventsModel {
  String? id;
  String? eventTitle;
  String? eventDescription;
  String? adminId;
  String? location;
  String? eventDate;
  String? eventTime;
  String? eventCreatedAt;
  List<String>? userIds;
  String? imageUrl;

  EventsModel({
    this.id,
    this.eventTitle,
    this.eventDescription,
    this.adminId,
    this.location,
    this.eventDate,
    this.eventTime,
    this.eventCreatedAt,
    this.userIds,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "eventTitle": eventTitle,
      "eventDescription": eventDescription,
      "adminId": adminId,
      "location": location,
      "eventDate": eventDate,
      "eventTime": eventTime,
      "eventCreatedAt": eventCreatedAt,
      "userIds": userIds,
      "imageUrl": imageUrl,
    };
  }

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      id: json['id'],
      eventTitle: json['eventTitle'],
      eventDescription: json['eventDescription'],
      adminId: json['adminId'],
      location: json['location'],
      eventDate: json['eventDate'],
      eventTime: json['eventTime'],
      eventCreatedAt: json['eventCreatedAt'],
      imageUrl: json['imageUrl'],
      userIds: json['userIds'] != null
          ? List<String>.from(json['userIds'])
          : null,
    );
  }

  @override
  String toString() {
    return 'EventsModel('
        'id: $id, '
        'eventTitle: $eventTitle, '
        'eventDescription: $eventDescription, '
        'adminId: $adminId, '
        'location: $location, '
        'eventDate: $eventDate, '
        'eventTime: $eventTime, '
        'eventCreatedAt: $eventCreatedAt, '
        'userIds: $userIds, '
        'imageUrl: $imageUrl'
        ')';
  }
}
