import 'dart:convert';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  final int? code;
  final String? message;
  final Data? data;
  final bool? success;

  ReportModel({
    this.code,
    this.message,
    this.data,
    this.success,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes?.toJson(),
  };
}

class Attributes {
  final List<Result>? results;
  final String? page;
  final String? limit;
  final int? totalPages;
  final int? totalResults;

  Attributes({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    totalResults: json["totalResults"],
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "totalResults": totalResults,
  };
}

class Result {
  final String? personId;
  final ReportId? reportId;
  final String? role;
  final String? reportType;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? customerReportId;

  Result({
    this.personId,
    this.reportId,
    this.role,
    this.reportType,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.customerReportId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    personId: json["personId"],
    reportId: json["reportId"] == null ? null : ReportId.fromJson(json["reportId"]),
    role: json["role"],
    reportType: json["reportType"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    customerReportId: json["_customerReportId"],
  );

  Map<String, dynamic> toJson() => {
    "personId": personId,
    "reportId": reportId?.toJson(),
    "role": role,
    "reportType": reportType,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "_customerReportId": customerReportId,
  };
}

class ReportId {
  final String? reportType;
  final String? incidentSevearity;
  final String? title;
  final String? reportId;

  ReportId({
    this.reportType,
    this.incidentSevearity,
    this.title,
    this.reportId,
  });

  factory ReportId.fromJson(Map<String, dynamic> json) => ReportId(
    reportType: json["reportType"],
    incidentSevearity: json["incidentSevearity"],
    title: json["title"],
    reportId: json["_reportId"],
  );

  Map<String, dynamic> toJson() => {
    "reportType": reportType,
    "incidentSevearity": incidentSevearity,
    "title": title,
    "_reportId": reportId,
  };
}