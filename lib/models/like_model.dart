class LikesModel {
  bool? like;
  String? uId;

  LikesModel({
    this.like,
    this.uId,
  });

  LikesModel.fromJson(Map<String, dynamic> json) {
    like = json['like'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      "like": like,
      "uId": uId,
    };
  }
}
