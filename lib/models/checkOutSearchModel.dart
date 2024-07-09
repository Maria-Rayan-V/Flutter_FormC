import 'package:flutter/material.dart';

class CheckOutSearchModel {
  String? applicationId;
  String? passportNumber;
  String? visaNumber;
  String? nationality;
  String? dateOfArrival;
  CheckOutSearchModel(
      {this.applicationId,
      this.passportNumber,
      this.visaNumber,
      this.nationality,
      this.dateOfArrival});
  CheckOutSearchModel.fromJson(Map<String?, dynamic> json)
      : this.applicationId = json['img'],
        this.passportNumber = json['name'],
        this.visaNumber = json['gender'],
        this.nationality = json['counoutind'],
        this.dateOfArrival = json['stateofrefinind'];

  Map<String?, dynamic> toJson() => {
        'img': applicationId,
        'name': passportNumber,
        'gender': visaNumber,
        'counoutind': nationality,
        'stateofrefinind': dateOfArrival,
      };
}
