// To parse this JSON data, do
//
//     final accotypeModel = accotypeModelFromJson(jsonString);

import 'dart:convert';

List<AccotypeModel> accotypeModelFromJson(String str) =>
    List<AccotypeModel>.from(
        json.decode(str).map((x) => AccotypeModel.fromJson(x)));

String accotypeModelToJson(List<AccotypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccotypeModel {
  AccotypeModel({
    this.accTypeCode,
    this.accTypeName,
  });

  String? accTypeCode;
  String? accTypeName;

  factory AccotypeModel.fromJson(Map<String, dynamic> json) => AccotypeModel(
        accTypeCode: json["acc_type_code"],
        accTypeName: json["acc_type_name"],
      );

  Map<String, dynamic> toJson() => {
        "acc_type_code": accTypeCode,
        "acc_type_name": accTypeName,
      };
}
