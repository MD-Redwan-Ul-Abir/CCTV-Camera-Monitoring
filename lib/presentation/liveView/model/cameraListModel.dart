// To parse this JSON data, do
//
//     final cameraListBySiteIdModel = cameraListBySiteIdModelFromJson(jsonString);

import 'dart:convert';

CameraListBySiteIdModel cameraListBySiteIdModelFromJson(String str) => CameraListBySiteIdModel.fromJson(json.decode(str));

String cameraListBySiteIdModelToJson(CameraListBySiteIdModel data) => json.encode(data.toJson());

class CameraListBySiteIdModel {
  final int? code;
  final String? message;
  final Data? data;
  final bool? success;

  CameraListBySiteIdModel({
    this.code,
    this.message,
    this.data,
    this.success,
  });

  factory CameraListBySiteIdModel.fromJson(Map<String, dynamic> json) => CameraListBySiteIdModel(
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
  final List<Attribute>? attributes;

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
  final CameraId? cameraId;
  final String? cameraPersonId;

  Attribute({
    this.cameraId,
    this.cameraPersonId,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    cameraId: json["cameraId"] == null ? null : CameraId.fromJson(json["cameraId"]),
    cameraPersonId: json["_CameraPersonId"],
  );

  Map<String, dynamic> toJson() => {
    "cameraId": cameraId?.toJson(),
    "_CameraPersonId": cameraPersonId,
  };
}

class CameraId {
  final String? cameraName;
  final String? rtspUrl;
  final String? cameraId;

  CameraId({
    this.cameraName,
    this.rtspUrl,
    this.cameraId,
  });

  factory CameraId.fromJson(Map<String, dynamic> json) => CameraId(
    cameraName: json["cameraName"],
    rtspUrl: json["rtspUrl"],
    cameraId: json["_cameraId"],
  );

  Map<String, dynamic> toJson() => {
    "cameraName": cameraName,
    "rtspUrl": rtspUrl,
    "_cameraId": cameraId,
  };
}
