import 'package:flutter/material.dart';

class ReferenceModel {
  String? applicationId;
  String? addrofrefinind;
  String? stateofrefinind;
  String? cityofrefinind;
  String? pincodeofref;
  String? mblnuminind;
  String? phnnuminind;
  String? mblnum;
  String? phnnum;
  String? employedinind;
  String? splcategorycode;
  String? purposeofvisit;
  ReferenceModel(
      {this.applicationId,
      this.phnnum,
      this.phnnuminind,
      this.mblnum,
      this.mblnuminind,
      this.employedinind,
      this.addrofrefinind,
      this.cityofrefinind,
      this.pincodeofref,
      this.purposeofvisit,
      this.splcategorycode,
      this.stateofrefinind});
  ReferenceModel.fromJson(Map<String?, dynamic> json)
      : this.applicationId = json['form_c_appl_id'],
        this.addrofrefinind = json['addrofrefinind'],
        this.stateofrefinind = json['stateofrefinind'],
        this.cityofrefinind = json['cityofrefinind'],
        this.pincodeofref = json['pincodeofref'],
        this.mblnuminind = json['mblnuminind'],
        this.phnnuminind = json['phnnuminind'],
        this.mblnum = json['mblnum'],
        this.phnnum = json['phnnum'],
        this.employedinind = json['employedinind'],
        this.splcategorycode = json['splcategorycode'],
        this.purposeofvisit = json['purposeofvisit'];
  Map<String?, dynamic> toJson() => {
        'form_c_appl_id': applicationId,
        'addrofrefinind': addrofrefinind,
        'stateofrefinind': stateofrefinind,
        'cityofrefinind': cityofrefinind,
        'pincodeofref': pincodeofref,
        'mblnuminind': mblnuminind,
        'phnnuminind': phnnuminind,
        'mblnum': mblnum,
        'phnnum': phnnum,
        'employedinind': employedinind,
        'splcategorycode': splcategorycode,
        'purposeofvisit': purposeofvisit,
      };
}
