import 'package:flutter/foundation.dart';

class ArrivalDetailsModel {
  String? name;
  String? nationality;
  String? passportNo;
  String? formCApplId;
  String? visaNo;
  String? dateOfArrivalInHotel;
  String? frroFroCode;
  String? nationalityName;
  String? img;
  String? timeOfArrivalInHotel;
  String? accoCode;

  ArrivalDetailsModel(
      {this.name,
      this.nationality,
      this.passportNo,
      this.formCApplId,
      this.visaNo,
      this.dateOfArrivalInHotel,
      this.frroFroCode,
      this.nationalityName,
      this.img,
      this.timeOfArrivalInHotel,
      this.accoCode});

  ArrivalDetailsModel.fromJson(Map<String?, dynamic> json) {
    name = json['name'];
    nationality = json['nationality'];
    passportNo = json['passport_no'];
    formCApplId = json['form_c_appl_id'];
    visaNo = json['visa_no'];
    dateOfArrivalInHotel = json['date_of_arrival_in_hotel'];
    frroFroCode = json['frro_fro_code'];
    nationalityName = json['nationality_name'];
    img = json['img'];
    timeOfArrivalInHotel = json['time_of_arrival_in_hotel'];
    accoCode = json['acco_code'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['name'] = this.name;
    data['nationality'] = this.nationality;
    data['passport_no'] = this.passportNo;
    data['form_c_appl_id'] = this.formCApplId;
    data['visa_no'] = this.visaNo;
    data['date_of_arrival_in_hotel'] = this.dateOfArrivalInHotel;
    data['frro_fro_code'] = this.frroFroCode;
    data['nationality_name'] = this.nationalityName;
    data['img'] = this.img;
    data['time_of_arrival_in_hotel'] = this.timeOfArrivalInHotel;
    data['acco_code'] = this.accoCode;
    return data;
  }
}
