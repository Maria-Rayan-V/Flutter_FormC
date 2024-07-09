class DistrictModel {
  String? _districtcode;
  String? _districtname;

  DistrictModel({String? districtcode, String? districtname}) {
    this._districtcode = districtcode;
    this._districtname = districtname;
  }

  String? get districtcode => _districtcode;
  set districtcode(String? districtcode) => _districtcode = districtcode;
  String? get districtname => _districtname;
  set districtname(String? districtname) => _districtname = districtname;

  DistrictModel.fromJson(Map<String, dynamic> json) {
    _districtcode = json['districtCode'];
    _districtname = json['districtName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtCode'] = this._districtcode;
    data['districtName'] = this._districtname;
    return data;
  }
}
