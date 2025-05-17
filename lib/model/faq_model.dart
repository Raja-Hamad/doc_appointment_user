class FaqModel {
  String? id;
  String? answer;
  String? question;
  String? adminId;
  FaqModel({this.answer, this.id, this.question, this.adminId});

  Map<String, dynamic> toMap() {
    return {
      "id": id ?? "",
      "answer": answer ?? "",
      "question": question ?? "",
      "adminId": adminId ?? "",
    };
  }

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? "",
      answer: json['answer'] ?? "",
      question: json['question'] ?? "",
      adminId: json['adminId'] ?? "",
    );
  }
  @override
  String toString() {
    return 'FaqModel('
        'id:$id, '
        'answer:$answer, '
        'question:$question, '
        'adminId:$adminId, '
        ')';
  }
}
