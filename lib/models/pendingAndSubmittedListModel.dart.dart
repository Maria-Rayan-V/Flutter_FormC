// To parse this JSON data, do
//
//     final pendingAndSubmittedModel = pendingAndSubmittedModelFromJson(jsonString?);

import 'dart:convert';

List<PendingAndSubmittedModel> pendingAndSubmittedModelFromJson(String? str) =>
    List<PendingAndSubmittedModel>.from(
        json.decode(str!).map((x) => PendingAndSubmittedModel.fromJson(x)));

String? pendingAndSubmittedModelToJson(List<PendingAndSubmittedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PendingAndSubmittedModel {
  PendingAndSubmittedModel(
      {this.formCApplId,
      this.givenName,
      this.surname,
      this.nationality,
      this.nationalityDesc,
      this.countryOutsideIndia,
      this.countryOutsideIndiaDesc,
      this.passnum,
      this.dob,
      this.img});
  String? dob;
  String? img;
  String? formCApplId;
  String? givenName;
  String? surname;
  String? nationality;
  String? nationalityDesc;
  String? countryOutsideIndia;
  String? countryOutsideIndiaDesc;
  String? passnum;

  factory PendingAndSubmittedModel.fromJson(Map<String?, dynamic> json) =>
      PendingAndSubmittedModel(
          formCApplId: json["form_c_appl_id"],
          givenName: json["given_name"],
          surname: json["surname"],
          nationality: json["nationality"],
          nationalityDesc: json["nationality_desc"],
          countryOutsideIndia: json["country_outside_india"],
          countryOutsideIndiaDesc: json["country_outside_india_desc"],
          passnum: json["passnum"],
          dob: json["dob"],
          img: json["img"]);

  Map<String?, dynamic> toJson() => {
        "form_c_appl_id": formCApplId,
        "given_name": givenName,
        "surname": surname,
        "nationality": nationality,
        "nationality_desc": nationalityDesc,
        "country_outside_india": countryOutsideIndia,
        "country_outside_india_desc": countryOutsideIndiaDesc,
        "passnum": passnum,
        "dob": dob,
        "img": img
      };
}
