class SocialUserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  SocialUserModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
    this.image,
    this.bio,
    this.cover,
    this.isEmailVerified,
  });

  SocialUserModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    bio = json['bio'];
    cover = json['cover'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "phone": phone,
      "uId": uId,
      "image": image,
      "bio": bio,
      "cover": cover,
      "isEmailVerified": isEmailVerified,
    };
  }
}
