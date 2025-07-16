import 'dart:convert';

class OtpVerifyModel {
  final int? code;
  final String? message;
  final Data? data;
  final bool? success;

  OtpVerifyModel({
    this.code,
    this.message,
    this.data,
    this.success,
  });

  factory OtpVerifyModel.fromRawJson(String str) => OtpVerifyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtpVerifyModel.fromJson(Map<String, dynamic> json) => OtpVerifyModel(
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
  final Result? result;

  Attributes({
    this.result,
  });

  factory Attributes.fromRawJson(String str) => Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
  };
}

class Result {
  final User? user;
  final Tokens? tokens;

  Result({
    this.user,
    this.tokens,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "tokens": tokens?.toJson(),
  };
}

class Tokens {
  final String? accessToken;
  final String? refreshToken;

  Tokens({
    this.accessToken,
    this.refreshToken,
  });

  factory Tokens.fromRawJson(String str) => Tokens.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };
}

class User {
  final String? userCustomId;
  final List<dynamic>? conversationRestrictWith;
  final bool? canMessage;
  final String? name;
  final String? email;
  final ProfileImage? profileImage;
  final String? status;
  final String? role;
  final String? address;
  final dynamic fcmToken;
  final String? subscriptionType;
  final bool? isEmailVerified;
  final bool? isDeleted;
  final bool? isResetPassword;
  final int? failedLoginAttempts;
  final dynamic stripeCustomerId;
  final String? authProvider;
  final bool? isGoogleVerified;
  final bool? isAppleVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? userId;

  User({
    this.userCustomId,
    this.conversationRestrictWith,
    this.canMessage,
    this.name,
    this.email,
    this.profileImage,
    this.status,
    this.role,
    this.address,
    this.fcmToken,
    this.subscriptionType,
    this.isEmailVerified,
    this.isDeleted,
    this.isResetPassword,
    this.failedLoginAttempts,
    this.stripeCustomerId,
    this.authProvider,
    this.isGoogleVerified,
    this.isAppleVerified,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.userId,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    userCustomId: json["user_custom_id"],
    conversationRestrictWith: json["conversation_restrict_with"] == null ? [] : List<dynamic>.from(json["conversation_restrict_with"]!.map((x) => x)),
    canMessage: json["canMessage"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profileImage"] == null ? null : ProfileImage.fromJson(json["profileImage"]),
    status: json["status"],
    role: json["role"],
    address: json["address"],
    fcmToken: json["fcmToken"],
    subscriptionType: json["subscriptionType"],
    isEmailVerified: json["isEmailVerified"],
    isDeleted: json["isDeleted"],
    isResetPassword: json["isResetPassword"],
    failedLoginAttempts: json["failedLoginAttempts"],
    stripeCustomerId: json["stripe_customer_id"],
    authProvider: json["authProvider"],
    isGoogleVerified: json["isGoogleVerified"],
    isAppleVerified: json["isAppleVerified"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    userId: json["_userId"],
  );

  Map<String, dynamic> toJson() => {
    "user_custom_id": userCustomId,
    "conversation_restrict_with": conversationRestrictWith == null ? [] : List<dynamic>.from(conversationRestrictWith!.map((x) => x)),
    "canMessage": canMessage,
    "name": name,
    "email": email,
    "profileImage": profileImage?.toJson(),
    "status": status,
    "role": role,
    "address": address,
    "fcmToken": fcmToken,
    "subscriptionType": subscriptionType,
    "isEmailVerified": isEmailVerified,
    "isDeleted": isDeleted,
    "isResetPassword": isResetPassword,
    "failedLoginAttempts": failedLoginAttempts,
    "stripe_customer_id": stripeCustomerId,
    "authProvider": authProvider,
    "isGoogleVerified": isGoogleVerified,
    "isAppleVerified": isAppleVerified,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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
