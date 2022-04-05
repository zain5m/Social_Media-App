import 'package:social/models/social_user_model.dart';

class NotificationModel {
  String? to;
  Data? data;

  NotificationModel({
    this.to,
    this.data,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "to": to,
      "data": data!.toMap(),
    };
  }
}

class Data {
  String? sender;
  String? text;
  SocialUserModel? resever;

  Data({this.text, this.sender, this.resever});

  Data.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    text = json['text'];
    resever = json['resever'] != null
        ? SocialUserModel.fromJson(json['resever'])
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "resever": resever!.toMap(),
    };
  }
}
