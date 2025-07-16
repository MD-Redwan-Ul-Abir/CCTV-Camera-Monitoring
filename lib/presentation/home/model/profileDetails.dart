import 'dart:convert';

class ProfileDetailsModel {
  final int? code;
  final String? message;
  final Data? data;

  ProfileDetailsModel({
    this.code,
    this.message,
    this.data,
  });

  factory ProfileDetailsModel.fromRawJson(String str) => ProfileDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) => ProfileDetailsModel(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final Attributes? attributes;

  Data({
    this.attributes,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes?.toJson(),
  };
}

class Attributes {
  final String? name;
  final ProfileImage? profileImage;
  final String? userId;

  Attributes({
    this.name,
    this.profileImage,
    this.userId,
  });

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    name: json["name"],
    profileImage: json["profileImage"] == null ? null : ProfileImage.fromJson(json["profileImage"]),
    userId: json["_userId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profileImage": profileImage?.toJson(),
    "_userId": userId,
  };
}

class ProfileImage {
  final String? imageUrl;
  final String? id;

  ProfileImage({
    this.imageUrl,
    this.id,
  });

  factory ProfileImage.fromRawJson(String str) => ProfileImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    imageUrl: json["imageUrl"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "_id": id,
  };
}
