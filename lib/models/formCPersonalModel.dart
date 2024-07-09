import 'package:flutter/material.dart';

class FormCPersonalModel {
  String? applicationId;
  String? name;
  String? surname;
  String? gender;
  String? dobFormat;
  String? dob;
  dynamic age;
  String? nationality;
  String? addressOutsideIndia;
  String? cityOutsideIndia;
  String? countryOutsideIndia;
  String? splcategory;
  FormCPersonalModel(
      {this.applicationId,
      this.name,
      this.surname,
      this.gender,
      this.dobFormat,
      this.dob,
      this.age,
      this.nationality,
      this.addressOutsideIndia,
      this.cityOutsideIndia,
      this.countryOutsideIndia,
      this.splcategory});
  FormCPersonalModel.fromJson(Map<String?, dynamic> json)
      : this.applicationId = json['form_c_appl_id'],
        this.name = json['name'],
        this.surname = json['surname'],
        this.gender = json['gender'],
        this.dobFormat = json['dobformat'],
        this.dob = json['dob'],
        this.nationality = json['nationality'],
        this.addressOutsideIndia = json['addroutind'],
        this.cityOutsideIndia = json['cityoutind'],
        this.countryOutsideIndia = json['counoutind'],
        this.splcategory = json['splcategorycode'];
  Map<String?, dynamic> toJson() => {
        'form_c_appl_id': applicationId,
        'name': name,
        'surname': surname,
        'gender': gender,
        'dobformat': dobFormat,
        'dob': dob,
        'nationality': nationality,
        'addroutind': addressOutsideIndia,
        'cityoutind': cityOutsideIndia,
        'counoutind': countryOutsideIndia,
        'splcategorycode': splcategory
      };
}
