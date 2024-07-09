// To parse this JSON data, do
//
//     final accomodatorModel = accomodatorModelFromJson(jsonString?);

import 'dart:convert';

AccomodatorModel accomodatorModelFromJson(String? str) =>
    AccomodatorModel.fromJson(json.decode(str!));

String? accomodatorModelToJson(AccomodatorModel data) =>
    json.encode(data.toJson());

class AccomodatorModel {
  AccomodatorModel({
    this.gender,
    this.nationality,
    this.dob,
    this.phoneNo,
    this.designation,
    this.userName,
    this.eMailId,
    this.mobileNo,
    this.accomName,
    this.accomCapacity,
    this.accomAddress,
    this.accomState,
    this.accomCityDist,
    this.frroTypeCode,
    this.accomodationType,
    this.accomodationGrade,
    this.accomEmail,
    this.accomMobile,
    this.accomPhoneNum,
    this.ownerDetails,
  });

  String? gender;
  String? nationality;
  String? dob;
  String? phoneNo;
  String? designation;
  String? userName;
  String? eMailId;
  String? mobileNo;
  String? accomName;
  String? accomCapacity;
  String? accomAddress;
  String? accomState;
  String? accomCityDist;
  String? frroTypeCode;
  String? accomodationType;
  String? accomodationGrade;
  String? accomEmail;
  String? accomMobile;
  String? accomPhoneNum;
  List<OwnerDetail>? ownerDetails;

  factory AccomodatorModel.fromJson(Map<String?, dynamic> json) =>
      AccomodatorModel(
        gender: json["gender"],
        nationality: json["nationality"],
        dob: json["dob"],
        phoneNo: json["phone_no"],
        designation: json["designation"],
        userName: json["user_name"],
        eMailId: json["e_mail_id"],
        mobileNo: json["mobile_no"],
        accomName: json["accomName"],
        accomCapacity: json["accomCapacity"],
        accomAddress: json["accomAddress"],
        accomState: json["accomState"],
        accomCityDist: json["accomCityDist"],
        frroTypeCode: json["frroTypeCode"],
        accomodationType: json["accomodationType"],
        accomodationGrade: json["accomodationGrade"],
        accomEmail: json["accomEmail"],
        accomMobile: json["accomMobile"],
        accomPhoneNum: json["accomPhoneNum"],
        ownerDetails: List<OwnerDetail>.from(
            json["ownerDetails"].map((x) => OwnerDetail.fromJson(x))),
      );

  Map<String?, dynamic> toJson() => {
        "gender": gender,
        "nationality": nationality,
        "dob": dob,
        "phone_no": phoneNo,
        "designation": designation,
        "user_name": userName,
        "e_mail_id": eMailId,
        "mobile_no": mobileNo,
        "accomName": accomName,
        "accomCapacity": accomCapacity,
        "accomAddress": accomAddress,
        "accomState": accomState,
        "accomCityDist": accomCityDist,
        "frroTypeCode": frroTypeCode,
        "accomodationType": accomodationType,
        "accomodationGrade": accomodationGrade,
        "accomEmail": accomEmail,
        "accomMobile": accomMobile,
        "accomPhoneNum": accomPhoneNum,
        "ownerDetails":
            List<dynamic>.from(ownerDetails!.map((x) => x.toJson())),
      };
}

class OwnerDetail {
  OwnerDetail({
    this.name,
    this.address,
    this.state,
    this.stateDesc,
    this.cityDist,
    this.cityDesc,
    this.emailId,
    this.phoneNum,
    this.mobile,
    this.accoCode,
    this.ownerCode,
    this.frroCode,
  });

  String? name;
  String? address;
  String? state;
  String? stateDesc;
  String? cityDist;
  String? cityDesc;
  String? emailId;
  String? phoneNum;
  String? mobile;
  dynamic accoCode;
  dynamic ownerCode;
  dynamic frroCode;

  factory OwnerDetail.fromJson(Map<String?, dynamic> json) => OwnerDetail(
        name: json["name"],
        address: json["address"],
        state: json["state"],
        stateDesc: json["stateDesc"],
        cityDist: json["cityDist"],
        cityDesc: json["cityDesc"],
        emailId: json["emailId"],
        phoneNum: json["phoneNum"],
        mobile: json["mobile"],
        accoCode: json["acco_code"],
        ownerCode: json["owner_code"],
        frroCode: json["frro_code"],
      );

  Map<String?, dynamic> toJson() => {
        "name": name,
        "address": address,
        "state": state,
        "stateDesc": stateDesc,
        "cityDist": cityDist,
        "cityDesc": cityDesc,
        "emailId": emailId,
        "phoneNum": phoneNum,
        "mobile": mobile,
        "acco_code": accoCode,
        "owner_code": ownerCode,
        "frro_code": frroCode,
      };
}
