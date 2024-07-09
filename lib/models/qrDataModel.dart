// To parse this JSON data, do
//
//     final accomodatorModel = accomodatorModelFromJson(jsonString?);

import 'dart:convert';

AccomodatorModel accomodatorModelFromJson(String? str) =>
    AccomodatorModel.fromJson(json.decode(str!));

String? accomodatorModelToJson(AccomodatorModel data) =>
    json.encode(data.toJson());

class AccomodatorModel {
  String? firstName;
  String? lastName;
  String? passportNumber;
  String? visaNumber;
  String? dob;

  AccomodatorModel({
    this.firstName,
    this.lastName,
    this.passportNumber,
    this.visaNumber,
    this.dob,
  });

  factory AccomodatorModel.fromJson(Map<String?, dynamic> json) =>
      AccomodatorModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        passportNumber: json["passport_number"],
        visaNumber: json["visa_number"],
        dob: json["dob"],
      );

  Map<String?, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "passport_number": passportNumber,
        "visa_number": visaNumber,
        "dob": dob,
      };
}
