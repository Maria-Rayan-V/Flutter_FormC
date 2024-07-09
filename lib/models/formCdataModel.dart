// To parse this JSON data, do
//
//     final formCDataModel = formCDataModelFromJson(jsonString?);

import 'dart:convert';

class FormCDataModel {
  FormCDataModel({
    this.formCApplicationId,
    this.accoCode,
    this.remark,
    this.enteredBy,
    this.enteredOn,
    this.givenName,
    this.surname,
    this.gender,
    this.genderDesc,
    this.dobFormat,
    this.dob,
    this.nationality,
    this.nationalityDesc,
    this.addrOutsideIndia,
    this.cityOutsideIndia,
    this.countryOutsideIndia,
    this.countryOutsideIndiaDesc,
    this.passportNumber,
    this.passportPlaceOfIssue,
    this.passportIssuedCountry,
    this.passportIssuedCountryDesc,
    this.passportIssuedDate,
    this.passportExpiryDate,
    this.visaNumber,
    this.visaIssuedPlace,
    this.visaIssuedCountry,
    this.visaIssuedCountryDesc,
    this.visaIssuedDate,
    this.visaExpiryDate,
    this.visatype,
    this.visatypeDesc,
    this.visaSubtype,
    this.visaSubtypeDesc,
    this.arrivedFromPlace,
    this.arrivedFromCity,
    this.arrivedFromCountry,
    this.arrivedFromCountryDesc,
    this.arrivalDateInIndia,
    this.arrivalDateInHotel,
    this.arrivalTimeInHotel,
    this.durationOfStay,
    this.nextDestPlaceInIndia,
    this.nextDestDistInIndia,
    this.nextDestDistInIndiaDesc,
    this.nextDestStateInIndia,
    this.nextDestStateInIndiaDesc,
    this.nextDestCountryFlag,
    this.nextDestPlaceOutsideIndia,
    this.nextDestCityOutsideIndia,
    this.nextDestCountryOutsideIndia,
    this.nextDestCountryOutsideIndiaDesc,
    this.addrOfReference,
    this.stateOfReference,
    this.stateOfReferenceDesc,
    this.cityOfReference,
    this.cityOfReferenceDesc,
    this.pincodeOfReference,
    this.mobileNumberInIndia,
    this.phoneNumberInIndia,
    this.mobileNumber,
    this.phoneNumber,
    this.employedInIndia,
    this.employedInIndiaDesc,
    this.splCategoryCode,
    this.splCategoryCodeDesc,
    this.purposeOfVisit,
    this.purposeOfVisitDesc,
    this.image,
    this.frroFroCode,
  });

  String? formCApplicationId;
  String? accoCode;
  dynamic remark;
  String? enteredBy;
  String? enteredOn;
  String? givenName;
  String? surname;
  String? gender;
  String? genderDesc;
  String? dobFormat;
  String? dob;
  String? nationality;
  String? nationalityDesc;
  String? addrOutsideIndia;
  String? cityOutsideIndia;
  String? countryOutsideIndia;
  String? countryOutsideIndiaDesc;
  String? passportNumber;
  String? passportPlaceOfIssue;
  String? passportIssuedCountry;
  String? passportIssuedCountryDesc;
  String? passportIssuedDate;
  String? passportExpiryDate;
  String? visaNumber;
  String? visaIssuedPlace;
  String? visaIssuedCountry;
  String? visaIssuedCountryDesc;
  String? visaIssuedDate;
  String? visaExpiryDate;
  String? visatype;
  dynamic visatypeDesc;
  String? visaSubtype;
  dynamic visaSubtypeDesc;
  String? arrivedFromPlace;
  String? arrivedFromCity;
  String? arrivedFromCountry;
  String? arrivedFromCountryDesc;
  String? arrivalDateInIndia;
  String? arrivalDateInHotel;
  String? arrivalTimeInHotel;
  String? durationOfStay;
  dynamic nextDestPlaceInIndia;
  dynamic nextDestDistInIndia;
  dynamic nextDestDistInIndiaDesc;
  dynamic nextDestStateInIndia;
  dynamic nextDestStateInIndiaDesc;
  String? nextDestCountryFlag;
  String? nextDestPlaceOutsideIndia;
  String? nextDestCityOutsideIndia;
  String? nextDestCountryOutsideIndia;
  String? nextDestCountryOutsideIndiaDesc;
  String? addrOfReference;
  String? stateOfReference;
  String? stateOfReferenceDesc;
  String? cityOfReference;
  String? cityOfReferenceDesc;
  String? pincodeOfReference;
  String? mobileNumberInIndia;
  String? phoneNumberInIndia;
  String? mobileNumber;
  String? phoneNumber;
  String? employedInIndia;
  dynamic employedInIndiaDesc;
  String? splCategoryCode;
  String? splCategoryCodeDesc;
  String? purposeOfVisit;
  String? purposeOfVisitDesc;
  String? image;
  String? frroFroCode;

  factory FormCDataModel.fromJson(Map<String?, dynamic> json) => FormCDataModel(
        formCApplicationId: json["form_c_appl_id"],
        accoCode: json["acco_code"],
        remark: json["remark"],
        enteredBy: json["entered_by"],
        enteredOn: json["entered_on"],
        givenName: json["name"],
        surname: json["surname"],
        gender: json["gender"],
        genderDesc: json["genderDesc"],
        dobFormat: json["dobformat"],
        dob: json["dob"],
        nationality: json["nationality"],
        nationalityDesc: json["nationalityDesc"],
        addrOutsideIndia: json["addroutind"],
        cityOutsideIndia: json["cityoutind"],
        countryOutsideIndia: json["counoutind"],
        countryOutsideIndiaDesc: json["counoutindDesc"],
        passportNumber: json["passnum"],
        passportPlaceOfIssue: json["passplace"],
        passportIssuedCountry: json["passcoun"],
        passportIssuedCountryDesc: json["passcounDesc"],
        passportIssuedDate: json["passdate"],
        passportExpiryDate: json["passexpdate"],
        visaNumber: json["visanum"],
        visaIssuedPlace: json["visaplace"],
        visaIssuedCountry: json["visacoun"],
        visaIssuedCountryDesc: json["visacounDesc"],
        visaIssuedDate: json["visadate"],
        visaExpiryDate: json["visaexpdate"],
        visatype: json["visatype"],
        visatypeDesc: json["visatypeDesc"],
        visaSubtype: json["visasubtype"],
        visaSubtypeDesc: json["visasubtypeDesc"],
        arrivedFromPlace: json["arriplace"],
        arrivedFromCity: json["arricit"],
        arrivedFromCountry: json["arricoun"],
        arrivedFromCountryDesc: json["arricounDesc"],
        arrivalDateInIndia: json["arridateind"],
        arrivalDateInHotel: json["arridatehotel"],
        arrivalTimeInHotel: json["arritimehotel"],
        durationOfStay: json["durationofstay"],
        nextDestPlaceInIndia: json["nextdestplaceinind"],
        nextDestDistInIndia: json["nextdestdistinind"],
        nextDestDistInIndiaDesc: json["nextdestdistinindDesc"],
        nextDestStateInIndia: json["nextdeststateinind"],
        nextDestStateInIndiaDesc: json["nextdeststateinindDesc"],
        nextDestCountryFlag: json["nextdestcounflag"],
        nextDestPlaceOutsideIndia: json["nextdestplaceoutind"],
        nextDestCityOutsideIndia: json["nextdestcityoutind"],
        nextDestCountryOutsideIndia: json["nextdestcounoutind"],
        nextDestCountryOutsideIndiaDesc: json["nextdestcounoutindDesc"],
        addrOfReference: json["addrofrefinind"],
        stateOfReference: json["stateofrefinind"],
        stateOfReferenceDesc: json["stateofrefinindDesc"],
        cityOfReference: json["cityofrefinind"],
        cityOfReferenceDesc: json["cityofrefinindDesc"],
        pincodeOfReference: json["pincodeofref"],
        mobileNumberInIndia: json["mblnuminind"],
        phoneNumberInIndia: json["phnnuminind"],
        mobileNumber: json["mblnum"],
        phoneNumber: json["phnnum"],
        employedInIndia: json["employedinind"],
        employedInIndiaDesc: json["employedinindDesc"],
        splCategoryCode: json["splcategorycode"],
        splCategoryCodeDesc: json["splcategorycodeDesc"],
        purposeOfVisit: json["purposeofvisit"],
        purposeOfVisitDesc: json["purposeofvisitDesc"],
        image: json["img"],
        frroFroCode: json["frro_fro_code"],
      );

  Map<String?, dynamic> toJson() => {
        "form_c_appl_id": formCApplicationId,
        "acco_code": accoCode,
        "remark": remark,
        "entered_by": enteredBy,
        "entered_on": enteredOn,
        "name": givenName,
        "surname": surname,
        "gender": gender,
        "genderDesc": genderDesc,
        "dobformat": dobFormat,
        "dob": dob,
        "nationality": nationality,
        "nationalityDesc": nationalityDesc,
        "addroutind": addrOutsideIndia,
        "cityoutind": cityOutsideIndia,
        "counoutind": countryOutsideIndia,
        "counoutindDesc": countryOutsideIndiaDesc,
        "passnum": passportNumber,
        "passplace": passportPlaceOfIssue,
        "passcoun": passportIssuedCountry,
        "passcounDesc": passportIssuedCountryDesc,
        "passdate": passportIssuedDate,
        "passexpdate": passportExpiryDate,
        "visanum": visaNumber,
        "visaplace": visaIssuedPlace,
        "visacoun": visaIssuedCountry,
        "visacounDesc": visaIssuedCountryDesc,
        "visadate": visaIssuedDate,
        "visaexpdate": visaExpiryDate,
        "visatype": visatype,
        "visatypeDesc": visatypeDesc,
        "visaSubtype": visaSubtype,
        "visaSubtypeDesc": visaSubtypeDesc,
        "arriplace": arrivedFromPlace,
        "arricit": arrivedFromCity,
        "arricoun": arrivedFromCountry,
        "arricounDesc": arrivedFromCountryDesc,
        "arridateind": arrivalDateInIndia,
        "arridatehotel": arrivalDateInHotel,
        "arritimehotel": arrivalTimeInHotel,
        "durationofstay": durationOfStay,
        "nextdestplaceinind": nextDestPlaceInIndia,
        "nextdestdistinind": nextDestDistInIndia,
        "nextdestdistinindDesc": nextDestDistInIndiaDesc,
        "nextdeststateinind": nextDestStateInIndia,
        "nextdeststateinindDesc": nextDestStateInIndiaDesc,
        "nextdestcounflag": nextDestCountryFlag,
        "nextdestplaceoutind": nextDestPlaceOutsideIndia,
        "nextdestcityoutind": nextDestCityOutsideIndia,
        "nextdestcounoutind": nextDestCountryOutsideIndia,
        "nextdestcounoutindDesc": nextDestCountryOutsideIndiaDesc,
        "addrofrefinind": addrOfReference,
        "stateofrefinind": stateOfReference,
        "stateofrefinindDesc": stateOfReferenceDesc,
        "cityofrefinind": cityOfReference,
        "cityofrefinindDesc": cityOfReferenceDesc,
        "pincodeofref": pincodeOfReference,
        "mblnuminind": mobileNumberInIndia,
        "phnnuminind": phoneNumberInIndia,
        "mblnum": mobileNumber,
        "phnnum": phoneNumber,
        "employedinind": employedInIndia,
        "employedinindDesc": employedInIndiaDesc,
        "splcategorycode": splCategoryCode,
        "splcategorycodeDesc": splCategoryCodeDesc,
        "purposeofvisit": purposeOfVisit,
        "purposeofvisitDesc": purposeOfVisitDesc,
        "img": image,
        "frro_fro_code": frroFroCode,
      };
}
