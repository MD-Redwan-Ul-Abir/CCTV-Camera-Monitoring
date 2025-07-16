import 'dart:convert';

class GetReportByIdModel {
  final int? code;
  final String? message;
  final Data? data;
  final bool? success;

  GetReportByIdModel({
    this.code,
    this.message,
    this.data,
    this.success,
  });

  factory GetReportByIdModel.fromRawJson(String str) => GetReportByIdModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReportByIdModel.fromJson(Map<String, dynamic> json) => GetReportByIdModel(
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
  final List<Result>? results;
  final int? page;
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

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
  final DateTime? createdAt;
  final String? customerReportId;

  Result({
    this.personId,
    this.reportId,
    this.role,
    this.createdAt,
    this.customerReportId,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    personId: json["personId"],
    reportId: json["reportId"] == null ? null : ReportId.fromJson(json["reportId"]),
    role: json["role"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    customerReportId: json["_customerReportId"],
  );

  Map<String, dynamic> toJson() => {
    "personId": personId,
    "reportId": reportId?.toJson(),
    "role": role,
    "createdAt": createdAt?.toIso8601String(),
    "_customerReportId": customerReportId,
  };
}

class ReportId {
  final String? reportType;
  final String? incidentSevearity;
  final String? title;
  final String? description;
  final String? reportId;

  ReportId({
    this.reportType,
    this.incidentSevearity,
    this.title,
    this.description,
    this.reportId,
  });

  factory ReportId.fromRawJson(String str) => ReportId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportId.fromJson(Map<String, dynamic> json) => ReportId(
    reportType: json["reportType"],
    incidentSevearity: json["incidentSevearity"],
    title: json["title"],
    description: json["description"],
    reportId: json["_reportId"],
  );

  Map<String, dynamic> toJson() => {
    "reportType": reportType,
    "incidentSevearity": incidentSevearity,
    "title": title,
    "description": description,
    "_reportId": reportId,
  };
}
