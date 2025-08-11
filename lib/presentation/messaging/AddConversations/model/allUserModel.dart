// To parse this JSON data, do
//
//     final allConversationsBetweenTwoUserModel = allConversationsBetweenTwoUserModelFromJson(jsonString);

import 'dart:convert';

AllConversationsBetweenTwoUserModel allConversationsBetweenTwoUserModelFromJson(String str) => AllConversationsBetweenTwoUserModel.fromJson(json.decode(str));

String allConversationsBetweenTwoUserModelToJson(AllConversationsBetweenTwoUserModel data) => json.encode(data.toJson());

class AllConversationsBetweenTwoUserModel {
  int? code;
  String? message;
  Data? data;
  bool? success;

  AllConversationsBetweenTwoUserModel({
    this.code,
    this.message,
    this.data,
    this.success,
  });

  factory AllConversationsBetweenTwoUserModel.fromJson(Map<String, dynamic> json) => AllConversationsBetweenTwoUserModel(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "success": success,
  };
}

class Data {
  List<Attribute>? attributes;

  Data({
    this.attributes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
  };
}

class Attribute {
  PersonId? personId;
  String? siteId;

  Attribute({
    this.personId,
    this.siteId,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    personId: json["personId"] == null ? null : PersonId.fromJson(json["personId"]),
    siteId: json["siteId"],
  );

  Map<String, dynamic> toJson() => {
    "personId": personId?.toJson(),
    "siteId": siteId,
  };
}

class PersonId {
  String? name;
  ProfileImage? profileImage;
  String? role;
  bool? canMessage;
  String? userId;

  PersonId({
    this.name,
    this.profileImage,
    this.role,
    this.canMessage,
    this.userId,
  });

  factory PersonId.fromJson(Map<String, dynamic> json) => PersonId(
    name: json["name"],
    profileImage: json["profileImage"] == null ? null : ProfileImage.fromJson(json["profileImage"]),
    role: json["role"],
    canMessage: json["canMessage"],
    userId: json["_userId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profileImage": profileImage?.toJson(),
    "role": role,
    "canMessage": canMessage,
    "_userId": userId,
  };
}

class ProfileImage {
  String? imageUrl;
  String? id;

  ProfileImage({
    this.imageUrl,
    this.id,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    imageUrl: json["imageUrl"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "_id": id,
  };
}
