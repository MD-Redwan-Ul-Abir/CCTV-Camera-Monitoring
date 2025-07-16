import 'dart:convert';

class GetAllSitesBySiteIdModel {
  final int? code;
  final String? message;
  final Data? data;
  final bool? success;

  GetAllSitesBySiteIdModel({
    this.code,
    this.message,
    this.data,
    this.success,
  });

  factory GetAllSitesBySiteIdModel.fromRawJson(String str) => GetAllSitesBySiteIdModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllSitesBySiteIdModel.fromJson(Map<String, dynamic> json) => GetAllSitesBySiteIdModel(
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
  final UserInfo? userInfo;

  Attributes({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
    this.userInfo,
  });

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    totalResults: json["totalResults"],
    userInfo: json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "totalResults": totalResults,
    "userInfo": userInfo?.toJson(),
  };
}

class Result {
  final String? personId;
  final SiteId? siteId;
  final String? userSiteId;

  Result({
    this.personId,
    this.siteId,
    this.userSiteId,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    personId: json["personId"],
    siteId: json["siteId"] == null ? null : SiteId.fromJson(json["siteId"]),
    userSiteId: json["_userSiteId"],
  );

  Map<String, dynamic> toJson() => {
    "personId": personId,
    "siteId": siteId?.toJson(),
    "_userSiteId": userSiteId,
  };
}

class SiteId {
  final String? name;
  final String? type;
  final List<Attachment>? attachments;
  final DateTime? createdAt;
  final String? siteId;

  SiteId({
    this.name,
    this.type,
    this.attachments,
    this.createdAt,
    this.siteId,
  });

  factory SiteId.fromRawJson(String str) => SiteId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SiteId.fromJson(Map<String, dynamic> json) => SiteId(
    name: json["name"],
    type: json["type"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    siteId: json["_siteId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "_siteId": siteId,
  };
}

class Attachment {
  final String? attachment;
  final String? attachmentId;

  Attachment({
    this.attachment,
    this.attachmentId,
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

class UserInfo {
  final String? name;
  final ProfileImage? profileImage;
  final String? role;
  final String? userId;

  UserInfo({
    this.name,
    this.profileImage,
    this.role,
    this.userId,
  });

  factory UserInfo.fromRawJson(String str) => UserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    name: json["name"],
    profileImage: json["profileImage"] == null ? null : ProfileImage.fromJson(json["profileImage"]),
    role: json["role"],
    userId: json["_userId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profileImage": profileImage?.toJson(),
    "role": role,
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
