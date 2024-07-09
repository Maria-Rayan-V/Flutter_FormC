// To parse this JSON data, do
//
//     final accoGradeModel = accoGradeModelFromJson(jsonString);

import 'dart:convert';

List<AccoGradeModel> accoGradeModelFromJson(String str) =>
    List<AccoGradeModel>.from(
        json.decode(str).map((x) => AccoGradeModel.fromJson(x)));

String accoGradeModelToJson(List<AccoGradeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccoGradeModel {
  AccoGradeModel({
    this.accoGrade,
    this.accoGradeDesc,
  });

  String? accoGrade;
  String? accoGradeDesc;

  factory AccoGradeModel.fromJson(Map<String, dynamic> json) => AccoGradeModel(
        accoGrade: json["acco_grade"],
        accoGradeDesc: json["acco_grade_desc"],
      );

  Map<String, dynamic> toJson() => {
        "acco_grade": accoGrade,
        "acco_grade_desc": accoGradeDesc,
      };
}
