import 'dart:convert';

IncomeModel incomeModelFromJson(String str) =>
    IncomeModel.fromJson(json.decode(str));

String incomeModelToJson(IncomeModel data) => json.encode(data.toJson());

class IncomeModel {
  double? income;
  double? expenses;
  double? savings;

  IncomeModel({
    this.income,
    this.expenses,
    this.savings,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
        income: json["income"],
        expenses: json["expenses"],
        savings: json["savings"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};

    if (income != null) jsonMap["income"] = income;
    if (expenses != null) jsonMap["expenses"] = expenses;
    if (savings != null) jsonMap["savings"] = savings;

    return jsonMap;
  }
}
