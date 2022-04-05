class CommentsModel {
  String? text;
  String? uId;
  String? name;
  String? image;
  String? dateTime;

  CommentsModel({this.text, this.uId, this.name, this.image, this.dateTime});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "uId": uId,
      "name": name,
      "image": image,
      "dateTime": dateTime,
    };
  }
}
