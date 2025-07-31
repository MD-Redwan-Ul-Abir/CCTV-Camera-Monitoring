// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  bool? success;
  Data? data;

  ReportModel({
    this.success,
    this.data,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  List<AllConversationList>? results;
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
    results: json["results"] == null ? [] : List<AllConversationList>.from(json["results"]!.map((x) => AllConversationList.fromJson(x))),
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

class AllConversationList {
  UserId? userId;
  List<Conversation>? conversations;
  bool? isOnline;

  AllConversationList({
    this.userId,
    this.conversations,
    this.isOnline,
  });

  factory AllConversationList.fromJson(Map<String, dynamic> json) => AllConversationList(
    userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
    conversations: json["conversations"] == null ? [] : List<Conversation>.from(json["conversations"]!.map((x) => Conversation.fromJson(x))),
    isOnline: json["isOnline"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId?.toJson(),
    "conversations": conversations == null ? [] : List<dynamic>.from(conversations!.map((x) => x.toJson())),
    "isOnline": isOnline,
  };
}

class Conversation {
  String? conversationId;
  LastMessage? lastMessage;
  DateTime? updatedAt;

  Conversation({
    this.conversationId,
    this.lastMessage,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    conversationId: json["_conversationId"],
    lastMessage: json["lastMessage"] == null ? null : LastMessage.fromJson(json["lastMessage"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_conversationId": conversationId,
    "lastMessage": lastMessage?.toJson(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class LastMessage {
  String? text;
  List<String>? attachments;
  String? senderId;
  String? conversationId;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? messageId;

  LastMessage({
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

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    text: json["text"],
    attachments: json["attachments"] == null ? [] : List<String>.from(json["attachments"]!.map((x) => x)),
    senderId: json["senderId"],
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
    "senderId": senderId,
    "conversationId": conversationId,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "_messageId": messageId,
  };
}

class UserId {
  String? userId;
  String? name;
  ProfileImage? profileImage;
  String? role;

  UserId({
    this.userId,
    this.name,
    this.profileImage,
    this.role,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    userId: json["_userId"],
    name: json["name"],
    profileImage: json["profileImage"] == null ? null : ProfileImage.fromJson(json["profileImage"]),
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "_userId": userId,
    "name": name,
    "profileImage": profileImage?.toJson(),
    "role": role,
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
