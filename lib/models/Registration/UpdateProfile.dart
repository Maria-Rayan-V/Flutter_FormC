// To parse this JSON data, do
//
//     final updateProfile = updateProfileFromJson(jsonString?);

import 'dart:convert';

UpdateProfile updateProfileFromJson(String? str) =>
    UpdateProfile.fromJson(json.decode(str!));

String? updateProfileToJson(UpdateProfile data) => json.encode(data.toJson());

class UpdateProfile {
  UpdateProfile({
    this.userid,
    this.gender,
    this.dob,
    this.designation,
    this.phoneNo,
    this.nationality,
  });

  String? userid;
  String? gender;
  String? dob;
  String? designation;
  String? phoneNo;
  String? nationality;

  factory UpdateProfile.fromJson(Map<String?, dynamic> json) => UpdateProfile(
        userid: json["userid"],
        gender: json["gender"],
        dob: json["dob"],
        designation: json["designation"],
        phoneNo: json["phoneNo"],
        nationality: json["nationality"],
      );

  Map<String?, dynamic> toJson() => {
        "userid": userid,
        "gender": gender,
        "dob": dob,
        "designation": designation,
        "phoneNo": phoneNo,
        "nationality": nationality,
      };
}
