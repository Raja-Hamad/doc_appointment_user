class HealthTipModel {
  String? title;
  String? description;
  String? author;
  String? imageUrl;
  String? datePosted;
  String? adminId;
  String? id;
  HealthTipModel({
    this.adminId,
    this.author,
    this.datePosted,
    this.description,
    this.id,
    this.imageUrl,
    this.title,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "title": title ?? "",
      "description": description ?? "",
      "imageUrl": imageUrl ?? "",
      "datePosted": datePosted ?? "",
      "adminId": adminId ?? "",
      "author": author ?? "",
    };
  }

  factory HealthTipModel.fromJson(Map<String, dynamic> json) {
    return HealthTipModel(
      id: json['id'],
      adminId: json['adminId'],
      description: json['description'],
      title: json['title'],
      datePosted: json['datePosted'],
      author: json['author'],
      imageUrl: json['imageUrl'],
    );
  }
  @override
  String toString() {
    return 'HealthTipModel('
        'id:$id, '
        'description:$description, '
        'author:$author, '
        'title:$title, '
        'imageUrl:$imageUrl, '
        'datePosted:$datePosted, '
        'adminId:$adminId, '
        ')';
  }
}
