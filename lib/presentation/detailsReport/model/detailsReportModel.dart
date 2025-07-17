import 'dart:convert';

class DetailsReportModel {
  final int? code;
  final String? message;
  final Data? data;

  DetailsReportModel({
    this.code,
    this.message,
    this.data,
  });

  factory DetailsReportModel.fromRawJson(String str) => DetailsReportModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailsReportModel.fromJson(Map<String, dynamic> json) => DetailsReportModel(
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
  final SiteId? siteId;
  final String? reportType;
  final String? incidentSevearity;
  final String? title;
  final String? description;
  final List<Person>? person;
  final String? status;
  final List<Attachment>? attachments;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? reportId;

  Attributes({
    this.siteId,
    this.reportType,
    this.incidentSevearity,
    this.title,
    this.description,
    this.person,
    this.status,
    this.attachments,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.reportId,
  });

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    siteId: json["siteId"] == null ? null : SiteId.fromJson(json["siteId"]),
    reportType: json["reportType"],
    incidentSevearity: json["incidentSevearity"],
    title: json["title"],
    description: json["description"],
    person: json["person"] == null ? [] : List<Person>.from(json["person"]!.map((x) => Person.fromJson(x))),
    status: json["status"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    reportId: json["_reportId"],
  );

  Map<String, dynamic> toJson() => {
    "siteId": siteId?.toJson(),
    "reportType": reportType,
    "incidentSevearity": incidentSevearity,
    "title": title,
    "description": description,
    "person": person == null ? [] : List<dynamic>.from(person!.map((x) => x.toJson())),
    "status": status,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "_reportId": reportId,
  };
}

class Attachment {
  final String? attachment;

  Attachment({
    this.attachment,
  });

  factory Attachment.fromRawJson(String str) => Attachment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    attachment: json["attachment"],
  );

  Map<String, dynamic> toJson() => {
    "attachment": attachment,
  };
}

class Person {
  final PersonId? personId;
  final String? role;
  final String? customerReportId;

  Person({
    this.personId,
    this.role,
    this.customerReportId,
  });

  factory Person.fromRawJson(String str) => Person.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    personId: json["personId"] == null ? null : PersonId.fromJson(json["personId"]),
    role: json["role"],
    customerReportId: json["_customerReportId"],
  );

  Map<String, dynamic> toJson() => {
    "personId": personId?.toJson(),
    "role": role,
    "_customerReportId": customerReportId,
  };
}

class PersonId {
  final String? name;
  final String? email;
  final ProfileImage? profileImage;
  final String? userId;

  PersonId({
    this.name,
    this.email,
    this.profileImage,
    this.userId,
  });

  factory PersonId.fromRawJson(String str) => PersonId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonId.fromJson(Map<String, dynamic> json) => PersonId(
    name: json["name"],
    email: json["email"],
    profileImage: json["profileImage"] == null ? null : ProfileImage.fromJson(json["profileImage"]),
    userId: json["_userId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
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

class SiteId {
  final String? name;
  final String? address;
  final String? siteId;

  SiteId({
    this.name,
    this.address,
    this.siteId,
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
