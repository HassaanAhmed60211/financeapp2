import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  String? month;
  String? price;
  String? text;
  String? time;

  TransactionModel({
    this.month,
    this.price,
    this.text,
    this.time,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        month: json["month"],
        price: json["price"],
        text: json["text"],
        time: json["time"],
      );

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = {};
    if (month != null) data["month"] = month;
    if (price != null) data["price"] = price;
    if (text != null) data["text"] = text;
    if (time != null) data["time"] = time;
    return data.isNotEmpty ? data : null;
  }
}
