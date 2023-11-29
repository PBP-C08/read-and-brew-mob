// To parse this JSON data, do
//
//     final orderMember = orderMemberFromJson(jsonString);

import 'dart:convert';

List<OrderMember> orderMemberFromJson(String str) => List<OrderMember>.from(json.decode(str).map((x) => OrderMember.fromJson(x)));

String orderMemberToJson(List<OrderMember> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderMember {
    String model;
    int pk;
    Fields fields;

    OrderMember({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory OrderMember.fromJson(Map<String, dynamic> json) => OrderMember(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String foodName;
    String foodPrice;
    int amount;
    DateTime orderDate;

    Fields({
        required this.user,
        required this.foodName,
        required this.foodPrice,
        required this.amount,
        required this.orderDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        foodName: json["food_name"],
        foodPrice: json["food_price"],
        amount: json["amount"],
        orderDate: DateTime.parse(json["order_date"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "food_name": foodName,
        "food_price": foodPrice,
        "amount": amount,
        "order_date": orderDate.toIso8601String(),
    };
}
