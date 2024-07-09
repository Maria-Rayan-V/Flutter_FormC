class PurposeModel {
  String? _purposeCode;
  String? _purposedesc;

  PurposeModel({String? purposeCode, String? purposedesc}) {
    this._purposeCode = purposeCode;
    this._purposedesc = purposedesc;
  }

  String? get purposeCode => _purposeCode;
  set purposeCode(String? purposeCode) => _purposeCode = purposeCode;
  String? get purposedesc => _purposedesc;
  set purposedesc(String? purposedesc) => _purposedesc = purposedesc;

  PurposeModel.fromJson(Map<String, dynamic> json) {
    _purposeCode = json['purposeCode'];
    _purposedesc = json['purposeDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purposeCode'] = this._purposeCode;
    data['purposeDesc'] = this._purposedesc;
    return data;
  }
}
