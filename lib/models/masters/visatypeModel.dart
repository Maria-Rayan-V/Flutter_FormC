class VisatypeModel {
  String? _visatypecode;
  String? _visatypedesc;

  VisatypeModel({String? visatypecode, String? visatypedesc}) {
    this._visatypecode = visatypecode;
    this._visatypedesc = visatypedesc;
  }

  String? get visatypecode => _visatypecode;
  set visatypecode(String? visatypecode) => _visatypecode = visatypecode;
  String? get visatypedesc => _visatypedesc;
  set visatypedesc(String? visatypedesc) => _visatypedesc = visatypedesc;

  VisatypeModel.fromJson(Map<String, dynamic> json) {
    _visatypecode = json['visaTypeCode'];
    _visatypedesc = json['visaTypeDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visaTypeCode'] = this._visatypecode;
    data['visaTypeDesc'] = this._visatypedesc;
    return data;
  }
}
