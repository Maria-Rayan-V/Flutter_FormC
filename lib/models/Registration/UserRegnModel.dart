// To parse this JSON data, do
//
//     final userRegnModel = userRegnModelFromJson(jsonString?);

import 'dart:convert';

UserRegnModel userRegnModelFromJson(String? str) =>
    UserRegnModel.fromJson(json.decode(str!));

String? userRegnModelToJson(UserRegnModel data) => json.encode(data.toJson());

class UserRegnModel {
  UserRegnModel({
    this.userId,
    this.userName,
    this.password,
    this.confirmPassword,
    this.emailId,
    this.emailOtp,
    this.mobile,
    this.mobileOtp,
    this.captcha,
    this.clientIp,
  });

  String? userId;
  String? userName;
  String? password;
  String? confirmPassword;
  String? emailId;
  String? emailOtp;
  String? mobile;
  String? mobileOtp;
  String? captcha;
  String? clientIp;

  factory UserRegnModel.fromJson(Map<String?, dynamic> json) => UserRegnModel(
        userId: json["userId"],
        userName: json["userName"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
        emailId: json["emailId"],
        emailOtp: json["email_otp"],
        mobile: json["mobile"],
        mobileOtp: json["mobile_otp"],
        captcha: json["captcha"],
        clientIp: json["clientIp"],
      );

  Map<String?, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "password": password,
        "confirmPassword": confirmPassword,
        "emailId": emailId,
        "email_otp": emailOtp,
        "mobile": mobile,
        "mobile_otp": mobileOtp,
        "captcha": captcha,
        "clientIp": clientIp,
      };
}
