// To parse this JSON data, do
//
//     final allConversationsBetweenTwoUserModel = allConversationsBetweenTwoUserModelFromJson(jsonString);

import 'dart:convert';

AllConversationsBetweenTwoUserModel allConversationsBetweenTwoUserModelFromJson(String str) => AllConversationsBetweenTwoUserModel.fromJson(json.decode(str));

String allConversationsBetweenTwoUserModelToJson(AllConversationsBetweenTwoUserModel data) => json.encode(data.toJson());

class AllConversationsBetweenTwoUserModel {
  bool? success;
  Data? data;

  AllConversationsBetweenTwoUserModel({
    this.success,
    this.data,
  });

  factory AllConversationsBetweenTwoUserModel.fromJson(Map<String, dynamic> json) => AllConversationsBetweenTwoUserModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  List<Result>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  Data({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  String? text;
  List<dynamic>? attachments;
  SenderId? senderId;
  String? conversationId;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? messageId;

  Result({
    this.text,
    this.attachments,
    this.senderId,
    this.conversationId,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.messageId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    text: json["text"],
    attachments: json["attachments"] == null ? [] : List<dynamic>.from(json["attachments"]!.map((x) => x)),
    senderId: json["senderId"] == null ? null : SenderId.fromJson(json["senderId"]),
    conversationId: json["conversationId"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    messageId: json["_messageId"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
    "senderId": senderId?.toJson(),
    "conversationId": conversationId,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "_messageId": messageId,
  };
}

class SenderId {
  String? name;
  ProfileImage? profileImage;
  String? userId;

  SenderId({
    this.name,
    this.profileImage,
    this.userId,
  });

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
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
  String? imageUrl;
  String? id;

  ProfileImage({
    this.imageUrl,
    this.id,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    imageUrl: json["imageUrl"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "_id": id,
  };
}
