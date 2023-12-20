import 'dart:convert';

ExpenseAnalyticsModel expenseAnalyticsModelFromJson(String str) =>
    ExpenseAnalyticsModel.fromJson(json.decode(str));

String expenseAnalyticsModelToJson(ExpenseAnalyticsModel data) =>
    json.encode(data.toJson());

class ExpenseAnalyticsModel {
  List<dynamic>? perIncome;
  List<dynamic>? perExpense;
  List<dynamic>? perSaving;
  List<dynamic>? time;

  ExpenseAnalyticsModel({
    this.perIncome,
    this.perExpense,
    this.perSaving,
    this.time,
  });
  factory ExpenseAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      ExpenseAnalyticsModel(
        perIncome: json["perIncome"] == null
            ? []
            : List<String>.from(json["perIncome"]!.map((x) => x.toString())),
        perExpense: json["perExpense"] == null
            ? []
            : List<dynamic>.from(json["perExpense"]!.map(
                (x) => x is int ? x.toDouble() : x.toDouble(),
              )),
        perSaving: json["perSaving"] == null
            ? []
            : List<dynamic>.from(json["perSaving"]!.map(
                (x) => x is int ? x.toDouble() : x.toDouble(),
              )),
        time: json["time"] == null
            ? []
            : List<String>.from(json["time"]!.map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "perIncome": perIncome == null
            ? []
            : List<dynamic>.from(perIncome!.map((x) => x)),
        "perExpense": perExpense == null
            ? []
            : List<dynamic>.from(perExpense!.map((x) => x)),
        "perSaving": perSaving == null
            ? []
            : List<dynamic>.from(perSaving!.map((x) => x)),
        "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
      };
}
