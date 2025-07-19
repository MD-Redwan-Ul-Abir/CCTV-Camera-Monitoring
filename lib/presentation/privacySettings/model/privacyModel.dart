import 'dart:convert';

class PrivacySettingsModel {
  final int? code;
  final String? message;
  final Data? data;

  PrivacySettingsModel({
    this.code,
    this.message,
    this.data,
  });

  factory PrivacySettingsModel.fromRawJson(String str) => PrivacySettingsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) => PrivacySettingsModel(
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
  final List<Attribute>? attributes;

  Data({
    this.attributes,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
  };
}

class Attribute {
  final String? id;
  final String? type;
  final String? details;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final ContactUs? contactUs;

  Attribute({
    this.id,
    this.type,
    this.details,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.contactUs,
  });

  factory Attribute.fromRawJson(String str) => Attribute.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["_id"],
    type: json["type"],
    details: json["details"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    contactUs: json["contactUs"] == null ? null : ContactUs.fromJson(json["contactUs"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "details": details,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "contactUs": contactUs?.toJson(),
  };
}

class ContactUs {
  final String? phone;
  final String? email;
  final String? address;
  final String? availableTime;

  ContactUs({
    this.phone,
    this.email,
    this.address,
    this.availableTime,
  });

  factory ContactUs.fromRawJson(String str) => ContactUs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContactUs.fromJson(Map<String, dynamic> json) => ContactUs(
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    availableTime: json["available time"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "email": email,
    "address": address,
    "available time": availableTime,
  };
}
