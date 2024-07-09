class PassportVisaModel {
  String? applicationId;
  String? passportNumber;
  String? passportPlaceOfIssue;
  String? passportCountryOfIssue;
  String? passportDateOfIssue;
  String? passportExpiryDate;
  String? visaNumber;
  String? visaPlaceOfIssue;
  String? visaCountryOfIssue;
  String? visaDateOfIssue;
  String? visaExpiryDate;
  String? visatype;
  String? visasubtype;
  PassportVisaModel({
    this.applicationId,
    this.passportNumber,
    this.passportPlaceOfIssue,
    this.passportCountryOfIssue,
    this.passportDateOfIssue,
    this.passportExpiryDate,
    this.visaCountryOfIssue,
    this.visaDateOfIssue,
    this.visaExpiryDate,
    this.visaNumber,
    this.visaPlaceOfIssue,
    this.visasubtype,
    this.visatype,
  });
  PassportVisaModel.fromJson(Map<String?, dynamic> json)
      : this.applicationId = json['form_c_appl_id'],
        this.passportNumber = json['passnum'],
        this.passportPlaceOfIssue = json['passplace'],
        this.passportCountryOfIssue = json['passcoun'],
        this.passportDateOfIssue = json['passdate'],
        this.passportExpiryDate = json['passexpdate'],
        this.visaNumber = json['visanum'],
        this.visaPlaceOfIssue = json['visaplace'],
        this.visaCountryOfIssue = json['visacoun'],
        this.visaDateOfIssue = json['visadate'],
        this.visaExpiryDate = json['visaexpdate'],
        this.visatype = json['visatype'],
        this.visasubtype = json['visasubtype'];
  Map<String?, dynamic> toJson() => {
        'form_c_appl_id': applicationId,
        'passnum': passportNumber,
        'passplace': passportPlaceOfIssue,
        'passcoun': passportCountryOfIssue,
        'passdate': passportDateOfIssue,
        'passexpdate': passportExpiryDate,
        'visanum': visaNumber,
        'visaplace': visaPlaceOfIssue,
        'visacoun': visaCountryOfIssue,
        'visadate': visaDateOfIssue,
        'visaexpdate': visaExpiryDate,
        'visatype': visatype,
        'visasubtype': visasubtype,
      };
}
