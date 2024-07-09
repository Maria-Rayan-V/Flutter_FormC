import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/formCdataModel.dart';
import 'package:formc_showcase/models/masters/AccogradeModel.dart';
import 'package:formc_showcase/models/masters/accotypeModel.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:formc_showcase/models/masters/districtModel.dart';
import 'package:formc_showcase/models/masters/frroModel.dart';
import 'package:formc_showcase/models/masters/purposeModel.dart';
import 'package:formc_showcase/models/masters/splCategoryModel.dart';
import 'package:formc_showcase/models/masters/stateModel.dart';
import 'package:formc_showcase/models/masters/visaSubtypeModel.dart';
import 'package:formc_showcase/models/masters/visatypeModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:formc_showcase/util/httpUtil.dart' as httpUtils;

import '../models/Registration/AccoProfileModel.dart';

class FormCCommonServices {
  static Future<List<CountryModel>> getCountry() async {
    var country;
    var response = await http.get(Uri.parse(GET_COUNTRY_URL), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      country = (responseBody as List)
          .map((i) => new CountryModel.fromJson(i))
          .toList();

    return country;
  }

  static Future<List<SplCategoryModel>> getSplCategory() async {
    var splCategory;
    var response = await http.get(Uri.parse(GET_SPLCATEGORY_URL), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      splCategory = (responseBody as List)
          .map((i) => new SplCategoryModel.fromJson(i))
          .toList();

    return splCategory;
  }

  static Future<List<VisatypeModel>> getVisatype() async {
    var visatype;
    var response = await http.get(Uri.parse(GET_VISATYPE), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      visatype = (responseBody as List)
          .map((i) => new VisatypeModel.fromJson(i))
          .toList();

    return visatype;
  }

  static Future<List<AccotypeModel>> getAccotype() async {
    var accotype;
    var response = await http.get(Uri.parse(GET_ACCO_TYPE), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      accotype = (responseBody as List)
          .map((i) => new AccotypeModel.fromJson(i))
          .toList();

    return accotype;
  }

  static Future<List> getSpecificAccotype(String accoTypeCode) async {
    var accotype;
    var response =
        await http.get(Uri.parse(GET_ACCO_TYPE + '$accoTypeCode'), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      accotype = (responseBody as List)
          .map((i) => new AccotypeModel.fromJson(i))
          .toList();

    return accotype;
  }

  static Future<List<AccoGradeModel>> getAccoGrade() async {
    var accoGrade;
    var response = await http.get(Uri.parse(GET_ACCO_GRADE), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      accoGrade = (responseBody as List)
          .map((i) => new AccoGradeModel.fromJson(i))
          .toList();

    return accoGrade;
  }

  static Future<List> getSpecificAccoGrade(String accoGrade) async {
    var accoGrade;
    var response =
        await http.get(Uri.parse(GET_ACCO_GRADE + '$accoGrade'), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      accoGrade = (responseBody as List)
          .map((i) => new AccoGradeModel.fromJson(i))
          .toList();

    return accoGrade;
  }

  static Future<List<FrroModel>> getFrro(
      String passedstate, String passedCity) async {
    EasyLoading.show(status: 'Please Wait...');
    var frroList;
    //print('passedState :$passedstate');
    print(GET_FRRO_LIST + '$passedstate' + '/$passedCity');
    var response = await http.get(
        Uri.parse(GET_FRRO_LIST + '$passedstate' + '/$passedCity'),
        headers: {
          "Accept": "application/json",
          //  'Authorization': 'Bearer $token'
        });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      frroList =
          (responseBody as List).map((i) => new FrroModel.fromJson(i)).toList();
    EasyLoading.dismiss();

    return frroList;
  }

  static Future<List<DistrictModel>> getDistrict(String passedstate) async {
    EasyLoading.show(status: 'Please Wait...');
    var district;
    //print('passedState :$passedstate');
    print(GET_DISTRICT_URL + '$passedstate');
    var response =
        await http.get(Uri.parse(GET_DISTRICT_URL + '$passedstate'), headers: {
      "Accept": "application/json",
      //  'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      district = (responseBody as List)
          .map((i) => new DistrictModel.fromJson(i))
          .toList();
    EasyLoading.dismiss();

    return district;
  }

  static Future<List<StateModel>> getState() async {
    var state;
    var response = await http.get(Uri.parse(GET_STATE_URL), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      state = (responseBody as List)
          .map((i) => new StateModel.fromJson(i))
          .toList();

    return state;
  }

  static Future<List<PurposeModel>> getPurposeOfVisit() async {
    var purposeOfVisit;
    var response = await http.get(Uri.parse(GET_VISIT_PURPOSE_URL), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      purposeOfVisit = (responseBody as List)
          .map((i) => new PurposeModel.fromJson(i))
          .toList();

    return purposeOfVisit;
  }

  static String getStatusCodeError(var errorStatusCode) {
    var result;
    if (errorStatusCode == 417) {
      result = "Expectation Failed";
    }
    if (errorStatusCode == 400) {
      result = "Invalid input";
    }
    if (errorStatusCode == 408) {
      result = "Request time out";
    }
    if (errorStatusCode == 403) {
      result = "Forbidden access";
    }
    if (errorStatusCode == 401) {
      //print('inside 401');
      result = "Unauthorized Access";
    }
    if (errorStatusCode == 404) {
      result = "Resource not found";
    }
    if (errorStatusCode == 500) {
      result = "Internal server error. Please try again later.";
    }
    if (errorStatusCode == 503) {
      result =
          "Service is not available at the moment. Please try after sometime";
    }
    return result;
  }
  // static String getStatusCodeError(var errorStatusCode) {
  //   //print('inside error code check fn');
  //   var result;
  //   if (errorStatusCode == 400) {
  //     result = "Invalid input";
  //   } else if (errorStatusCode == 408) {
  //     result = "Request time out";
  //   } else if (errorStatusCode == 403) {
  //     result = "Forbidden access";
  //   } else if (errorStatusCode == 401) {
  //     //print('in 401 code');
  //     result = "Unauthorized Access";
  //   } else if (errorStatusCode == 404) {
  //     result = "Resource not found";
  //   } else if (errorStatusCode == 500) {
  //     result = "Internal server error. Please try again later.";
  //   } else if (errorStatusCode == 503) {
  //     result =
  //         "Service is not available at the moment. Please try after sometime";
  //   } else {
  //     result = "Something went wrong. Please try again later";
  //   }
  //   return result;
  // }

  static Future getFormCTempDetailsById(String tmpFileNumber) async {
    var token = await httpUtils.HttpUtils().getToken();
    //print(GET_FORMC_TEMPDETAILSBYAPPLID + '$tmpFileNumber');
    var formCFullDetails;
    var response = await http.get(
        Uri.parse(GET_FORMC_TEMPDETAILSBYAPPLID + '$tmpFileNumber'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        });
    var responseBody = json.decode(response.body);
    //print('response statuscode :${response.statusCode}');
    //print('success');
    //print('response body : ${response.body}');
    if (response.statusCode == 200)
      formCFullDetails = (responseBody as List)
          .map((i) => new FormCDataModel.fromJson(i))
          .toList();
    return formCFullDetails;
  }

  static Future<List<PurposeModel>> getSpecificPurposeOfVisit(
      String purposeCode) async {
    ////print('Single state url:' + GET_STATE_URL + '$stateCode');
    dynamic purpose;
    var response = await http
        .get(Uri.parse(GET_VISIT_PURPOSE_URL + '$purposeCode'), headers: {
      "Accept": "application/json",
      //  'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      purpose = (responseBody as List)
          .map((i) => new PurposeModel.fromJson(i))
          .toList();

    return purpose;
  }

  static Future<List<StateModel>> getSpecificState(String stateCode) async {
    //print('Single state url:' + GET_STATE_URL + '$stateCode');
    var state;
    var response =
        await http.get(Uri.parse(GET_STATE_URL + '$stateCode'), headers: {
      "Accept": "application/json",
      //  'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      state = (responseBody as List)
          .map((i) => new StateModel.fromJson(i))
          .toList();

    return state;
  }

  static Future<List<VisatypeModel>> getSpecificVisatype(
      String visatypecode) async {
    //  //print('Single state url:' + GET_STATE_URL + '$stateCode');
    var visatype;
    var response =
        await http.get(Uri.parse(GET_VISATYPE + '$visatypecode'), headers: {
      "Accept": "application/json",
      //  'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      visatype = (responseBody as List)
          .map((i) => new VisatypeModel.fromJson(i))
          .toList();

    return visatype;
  }

  static Future<List<CountryModel>> getSpecificCountry(
      String countryCode) async {
    //print('country code single: $countryCode');
    var country;
    var response =
        await http.get(Uri.parse(GET_COUNTRY_URL + '$countryCode'), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    //print('single country res:$responseBody');
    if (response.statusCode == 200)
      country = (responseBody as List)
          .map((i) => new CountryModel.fromJson(i))
          .toList();

    return country;
  }

  static Future<List<SplCategoryModel>> getSpecificSplCategory(
      String splCategoryCode) async {
    //print(GET_SPLCATEGORY_URL + '$splCategoryCode');
    dynamic specificCategory;
    var response = await http
        .get(Uri.parse(GET_SPLCATEGORY_URL + '$splCategoryCode'), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    ////print('single country res:$responseBody');
    if (response.statusCode == 200)
      specificCategory = (responseBody as List)
          .map((i) => new SplCategoryModel.fromJson(i))
          .toList();

    return specificCategory;
  }

  static Future getFormCSubmittedDetailsById(String tmpFileNumber) async {
    EasyLoading.show(status: 'Please Wait...');
    var formCFullDetails;
    //var token = await HttpUtils().getToken();
    var response = await http.get(
        Uri.parse(GET_APPLICANT_FULLDETAILS_URL + '$tmpFileNumber'),
        headers: {
          "Accept": "application/json",
          //  'Authorization': 'Bearer $token'
        });
    var responseBody = json.decode(response.body);
    //print('response statuscode :${response.statusCode}');
    //print('response body : ${response.body}');
    if (response.statusCode == 200)
      formCFullDetails = (responseBody as List)
          .map((i) => new FormCDataModel.fromJson(i))
          .toList();
    EasyLoading.dismiss();
    return formCFullDetails;
  }

  static Future<List<FormCDataModel>> getApplicantDetailByPassportNo(
      String pass, String nationality) async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await httpUtils.HttpUtils().getToken();
    var existingDetails;
    //print(GET_APPDETAILSBY_PASSPORTANDNATIONALITY_URL +
    //  'passportNo=$pass&nationality=$nationality');
    var res = await http.get(
        Uri.parse(GET_APPDETAILSBY_PASSPORTANDNATIONALITY_URL +
            'passportNo=$pass&nationality=$nationality'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        });
    var resBody = json.decode(res.body);
    if (res.statusCode == 200)
      existingDetails =
          (resBody as List).map((i) => new FormCDataModel.fromJson(i)).toList();

    EasyLoading.dismiss();
    return existingDetails;
  }

  static Future<List> getPendingApplByPassportNoAndNationality(
      String pass, String nationality) async {
    EasyLoading.show(status: 'Please Wait...');
    var existingDetails;
    var token = await httpUtils.HttpUtils().getToken();
    //print(GET_FORMC_PENDINGAPPL_BYPASSNOANDNAT +
    //'$pass&nationality=$nationality');
    var res = await http.get(
        Uri.parse(GET_FORMC_PENDINGAPPL_BYPASSNOANDNAT +
            '$pass&nationality=$nationality'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        });
    //print('res status :${res.statusCode}');
    //print(res.body);
    var resBody = json.decode(res.body);
    if (res.statusCode == 200)
      existingDetails =
          (resBody as List).map((i) => new FormCDataModel.fromJson(i)).toList();
    EasyLoading.dismiss();
    return existingDetails;
  }

  static Future<List<FormCDataModel>> getPendingDetailsByApplId(
      String applicationId) async {
    EasyLoading.show(status: 'Please Wait...');
    var pendingFormCDetails;
    var token = await httpUtils.HttpUtils().getToken();
    //print(GET_FORMC_TEMPDETAILSBYAPPLID + '$applicationId');
    var res = await http.get(
        Uri.parse(GET_FORMC_TEMPDETAILSBYAPPLID + '$applicationId'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        });
    var resBody = json.decode(res.body);
    if (res.statusCode == 200)
      pendingFormCDetails =
          (resBody as List).map((i) => new FormCDataModel.fromJson(i)).toList();
    //print('pendingformcdetailsinfun: $pendingFormCDetails');
    EasyLoading.dismiss();
    return pendingFormCDetails;
  }

  static Future<List<VisaSubtypeModel>> getVisaSubtype(String visatype) async {
    //EasyLoading.show(status: 'Loading Visa SubType...');
    var visasubtype;
    //print(GET_VISASUBTYPE + '$visatype');
    var response =
        await http.get(Uri.parse(GET_VISASUBTYPE + '$visatype'), headers: {
      "Accept": "application/json",
      // 'Authorization': 'Bearer $token'
    });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      visasubtype = (responseBody as List)
          .map((i) => new VisaSubtypeModel.fromJson(i))
          .toList();
    //EasyLoading.dismiss();

    //print('subtype $visasubtype');

    return visasubtype;
  }
}
