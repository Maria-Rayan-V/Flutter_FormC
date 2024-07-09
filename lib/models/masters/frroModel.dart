// To parse this JSON data, do
//
//     final frroModel = frroModelFromJson(jsonString);

import 'dart:convert';

List<FrroModel> frroModelFromJson(String str) =>
    List<FrroModel>.from(json.decode(str).map((x) => FrroModel.fromJson(x)));

String frroModelToJson(List<FrroModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FrroModel {
  FrroModel({
    this.frroFroCode,
    this.frroFroDesc,
  });

  String? frroFroCode;
  String? frroFroDesc;

  factory FrroModel.fromJson(Map<String, dynamic> json) => FrroModel(
        frroFroCode: json["frro_fro_code"],
        frroFroDesc: json["frro_fro_desc"],
      );

  Map<String, dynamic> toJson() => {
        "frro_fro_code": frroFroCode,
        "frro_fro_desc": frroFroDesc,
      };
}
