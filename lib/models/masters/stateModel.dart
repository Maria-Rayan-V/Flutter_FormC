class StateModel {
  String? _statecode;
  String? _statename;

  StateModel({String? statecode, String? statename}) {
    this._statecode = statecode;
    this._statename = statename;
  }

  String? get statecode => _statecode;
  set statecode(String? statecode) => _statecode = statecode;
  String? get statename => _statename;
  set statename(String? statename) => _statename = statename;

  StateModel.fromJson(Map<String, dynamic> json) {
    _statecode = json['stateCode'];
    _statename = json['ststeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateCode'] = this._statecode;
    data['ststeName'] = this._statename;
    return data;
  }
}
