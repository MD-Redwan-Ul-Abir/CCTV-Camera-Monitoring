import 'dart:convert';

class ForgetPassword {
  final int? code;
  final String? message;
  final Data? data;
  final bool? success;

  ForgetPassword({
    this.code,
    this.message,
    this.data,
    this.success,
  });

  factory ForgetPassword.fromRawJson(String str) => ForgetPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgetPassword.fromJson(Map<String, dynamic> json) => ForgetPassword(
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
  final String? resetPasswordToken;

  Attributes({
    this.resetPasswordToken,
  });

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    resetPasswordToken: json["resetPasswordToken"],
  );

  Map<String, dynamic> toJson() => {
    "resetPasswordToken": resetPasswordToken,
  };
}
