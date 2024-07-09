// To parse this JSON data, do
//
//     final editUsrProfileModel = editUsrProfileModelFromJson(jsonString?);

import 'dart:convert';

EditUsrProfileModel editUsrProfileModelFromJson(String? str) =>
    EditUsrProfileModel.fromJson(json.decode(str!));

String? editUsrProfileModelToJson(EditUsrProfileModel data) =>
    json.encode(data.toJson());

class EditUsrProfileModel {
  EditUsrProfileModel({
    this.userid,
    this.gender,
    this.dob,
    this.designation,
    this.phoneNo,
    this.nationality,
    this.otp,
    this.otpVerificationType,
  });

  String? userid;
  String? gender;
  String? dob;
  String? designation;
  String? phoneNo;
  String? nationality;
  String? otp;
  String? otpVerificationType;
  factory EditUsrProfileModel.fromJson(Map<String?, dynamic> json) =>
      EditUsrProfileModel(
          userid: json["userid"],
          gender: json["gender"],
          dob: json["dob"],
          designation: json["designation"],
          phoneNo: json["phone_no"],
          nationality: json["nationality"],
          otp: json["otp"],
          otpVerificationType: json["otpVerificationType"]);

  Map<String?, dynamic> toJson() => {
        "userid": userid,
        "gender": gender,
        "dob": dob,
        "designation": designation,
        "phone_no": phoneNo,
        "nationality": nationality,
        "otp": otp,
        "otpVerificationType": otpVerificationType
      };
}
