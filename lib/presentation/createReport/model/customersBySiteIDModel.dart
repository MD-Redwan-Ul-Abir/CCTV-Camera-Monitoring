import 'package:meta/meta.dart';
import 'dart:convert';

class CustomberBySiteIdModel {
  int code;
  String message;
  Data data;
  bool success;

  CustomberBySiteIdModel({
    required this.code,
    required this.message,
    required this.data,
    required this.success,
  });

  factory CustomberBySiteIdModel.fromRawJson(String str) => CustomberBySiteIdModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomberBySiteIdModel.fromJson(Map<String, dynamic> json) => CustomberBySiteIdModel(
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
    "success": success,
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
  bool hasCustomers;
  List<Customer> customers;

  Attributes({
    required this.hasCustomers,
    required this.customers,
  });

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    hasCustomers: json["hasCustomers"],
    customers: List<Customer>.from(json["customers"].map((x) => Customer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "hasCustomers": hasCustomers,
    "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
  };
}

class Customer {
  PersonId personId;
  String role;
  String userSiteId;

  Customer({
    required this.personId,
    required this.role,
    required this.userSiteId,
  });

  factory Customer.fromRawJson(String str) => Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    personId: PersonId.fromJson(json["personId"]),
    role: json["role"],
    userSiteId: json["_userSiteId"],
  );

  Map<String, dynamic> toJson() => {
    "personId": personId.toJson(),
    "role": role,
    "_userSiteId": userSiteId,
  };
}

class PersonId {
  String name;
  ProfileImage profileImage;
  String userId;

  PersonId({
    required this.name,
    required this.profileImage,
    required this.userId,
  });

  factory PersonId.fromRawJson(String str) => PersonId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonId.fromJson(Map<String, dynamic> json) => PersonId(
    name: json["name"],
    profileImage: ProfileImage.fromJson(json["profileImage"]),
    userId: json["_userId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profileImage": profileImage.toJson(),
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
