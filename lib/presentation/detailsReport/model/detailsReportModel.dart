import 'package:meta/meta.dart';
import 'dart:convert';

class DetailsReportModel {
  int code;
  String message;
  Data data;

  DetailsReportModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory DetailsReportModel.fromRawJson(String str) => DetailsReportModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailsReportModel.fromJson(Map<String, dynamic> json) => DetailsReportModel(
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Attributes attributes;

  Data({
    required this.attributes,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    attributes: Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes.toJson(),
  };
}

class Attributes {
  SiteId siteId;
  CreatorId creatorId;
  String reportType;
  String incidentSevearity;
  String title;
  String description;
  List<dynamic> person;
  String status;
  List<Attachment> attachments;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String reportId;

  Attributes({
    required this.siteId,
    required this.creatorId,
    required this.reportType,
    required this.incidentSevearity,
    required this.title,
    required this.description,
    required this.person,
    required this.status,
    required this.attachments,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.reportId,
  });

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    siteId: SiteId.fromJson(json["siteId"]),
    creatorId: CreatorId.fromJson(json["creatorId"]),
    reportType: json["reportType"],
    incidentSevearity: json["incidentSevearity"],
    title: json["title"],
    description: json["description"],
    person: List<dynamic>.from(json["person"].map((x) => x)),
    status: json["status"],
    attachments: List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    reportId: json["_reportId"],
  );

  Map<String, dynamic> toJson() => {
    "siteId": siteId.toJson(),
    "creatorId": creatorId.toJson(),
    "reportType": reportType,
    "incidentSevearity": incidentSevearity,
    "title": title,
    "description": description,
    "person": List<dynamic>.from(person.map((x) => x)),
    "status": status,
    "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "_reportId": reportId,
  };
}

class Attachment {
  String attachment;
  String attachmentId;

  Attachment({
    required this.attachment,
    required this.attachmentId,
  });

  factory Attachment.fromRawJson(String str) => Attachment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    attachment: json["attachment"],
    attachmentId: json["_attachmentId"],
  );

  Map<String, dynamic> toJson() => {
    "attachment": attachment,
    "_attachmentId": attachmentId,
  };
}

class CreatorId {
  String name;
  String email;
  String phoneNumber;
  ProfileImage profileImage;
  String role;
  String userId;

  CreatorId({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.role,
    required this.userId,
  });

  factory CreatorId.fromRawJson(String str) => CreatorId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatorId.fromJson(Map<String, dynamic> json) => CreatorId(
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    profileImage: ProfileImage.fromJson(json["profileImage"]),
    role: json["role"],
    userId: json["_userId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "profileImage": profileImage.toJson(),
    "role": role,
    "_userId": userId,
  };
}

class ProfileImage {
  String imageUrl;
  String id;

  ProfileImage({
    required this.imageUrl,
    required this.id,
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

class SiteId {
  String name;
  String address;
  String siteId;

  SiteId({
    required this.name,
    required this.address,
    required this.siteId,
  });

  factory SiteId.fromRawJson(String str) => SiteId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SiteId.fromJson(Map<String, dynamic> json) => SiteId(
    name: json["name"],
    address: json["address"],
    siteId: json["_siteId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "_siteId": siteId,
  };
}
