class ChatModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String id;
  final String timeStamp;

  ChatModel({
    required this.id,
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "message": message,
      "senderId": senderId,
      "receiverId": receiverId,
      "timeStamp": timeStamp,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      receiverId: json['receiverId'],
      senderId: json['senderId'],
      timeStamp: json['timeStamp'],
    );
  }

  @override
  String toString() {
    return 'ChatModel('
        'id: $id'
        'message: $message'
        'senderId: $senderId'
        'receiverId: $receiverId'
        'timeStamp: $timeStamp'
        ')';
  }
}
