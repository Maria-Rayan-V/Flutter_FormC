class SplCategoryModel {
  String? _splcategoryCode;
  String? _splcategoryDesc;

  SplCategoryModel({String? splcategoryCode, String? splcategoryDesc}) {
    this._splcategoryCode = splcategoryCode;
    this._splcategoryDesc = splcategoryDesc;
  }

  String? get splcategoryCode => _splcategoryCode;
  set splcategoryCode(String? splcategoryCode) =>
      _splcategoryCode = splcategoryCode;
  String? get splcategoryDesc => _splcategoryDesc;
  set splcategoryDesc(String? splcategoryDesc) =>
      _splcategoryDesc = splcategoryDesc;

  SplCategoryModel.fromJson(Map<String, dynamic> json) {
    _splcategoryCode = json['splCatCode'];
    _splcategoryDesc = json['splCatDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['splCatCode'] = this._splcategoryCode;
    data['splCatDesc'] = this._splcategoryDesc;
    return data;
  }
}
