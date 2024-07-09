class VisaSubtypeModel {
  String? _visasubtype;
  String? _purpose;
  String? _purposecode;

  VisaSubtypeModel(
      {String? visasubtype, String? purpose, String? purposecode}) {
    this._visasubtype = visasubtype;
    this._purpose = purpose;
    this._purposecode = purposecode;
  }

  String? get visasubtype => _visasubtype;
  set visasubtype(String? visasubtype) => _visasubtype = visasubtype;
  String? get purpose => _purpose;
  set purpose(String? purpose) => _purpose = purpose;
  String? get purposecode => _purposecode;
  set purposecode(String? purposecode) => _purposecode = purposecode;

  VisaSubtypeModel.fromJson(Map<String, dynamic> json) {
    _visasubtype = json['visaSubType'];
    _purpose = json['purpose'];
    _purposecode = json['purposeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visaSubType'] = this._visasubtype;
    data['purpose'] = this._purpose;
    data['purposeCode'] = this._purposecode;
    return data;
  }
}
