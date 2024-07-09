class CountryModel {
  String? _countrycode;
  String? _countryname;

  CountryModel({String? servicecode, String? servicename}) {
    this._countrycode = servicecode;
    this._countryname = servicename;
  }

  String? get countrycode => _countrycode;
  set countrycode(String? countrycode) => _countrycode = countrycode;
  String? get countryname => _countryname;
  set countryname(String? countryname) => _countryname = countryname;

  CountryModel.fromJson(Map<String, dynamic> json) {
    _countrycode = json['country_code'];
    _countryname = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this._countrycode;
    data['country_name'] = this._countryname;
    return data;
  }
}
