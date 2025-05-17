import 'package:cloud_firestore/cloud_firestore.dart';

class HealthTrackerModel {
  String? id;
  String? uid;
  String? today;
  String? mood;
  double? sleep;
  int? steps;
  double? waterIntake;
  Timestamp? createdAt; // ✅ Updated

  HealthTrackerModel({
    this.id,
    this.uid,
    this.today,
    this.mood,
    this.sleep,
    this.steps,
    this.waterIntake,
    this.createdAt,
  });

Map<String, dynamic> toJson() {
  return {
    "id": id ?? "",
    "uid": uid ?? "",
    "today": today ?? "",
    "mood": mood ?? "",
    "sleep": sleep ?? 0.0,
    "steps": steps ?? 0,
    "waterIntake": waterIntake ?? 0.0,
    "createdAt": createdAt ?? FieldValue.serverTimestamp(), // ✅ No error here
  };
}

 factory HealthTrackerModel.fromJson(Map<String, dynamic> json) {
  final createdAtField = json['createdAt'];

  return HealthTrackerModel(
    id: json['id'] ?? "",
    uid: json['uid'] ?? "",
    today: json['today'] ?? "",
    mood: json['mood'] ?? "",
    sleep: (json['sleep'] ?? 0.0).toDouble(),
    steps: (json['steps'] ?? 0).toInt(),
    waterIntake: (json['waterIntake'] ?? 0.0).toDouble(),
    createdAt: createdAtField is Timestamp ? createdAtField : null, // ✅ safe casting
  );
}


  @override
  String toString() {
    return 'HealthTrackerModel('
        'id: $id, uid: $uid, mood: $mood, sleep: $sleep, '
        'waterIntake: $waterIntake, today: $today, '
        'createdAt: $createdAt, steps: $steps)';
  }
}
