// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    String model;
    int pk;
    Fields fields;

    Order({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
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
    String foodName;
    String foodPrice;
    int amount;
    DateTime orderDate;

    Fields({
        required this.foodName,
        required this.foodPrice,
        required this.amount,
        required this.orderDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        foodName: json["food_name"],
        foodPrice: json["food_price"],
        amount: json["amount"],
        orderDate: DateTime.parse(json["order_date"]),
    );

    Map<String, dynamic> toJson() => {
        "food_name": foodName,
        "food_price": foodPrice,
        "amount": amount,
        "order_date": orderDate.toIso8601String(),
    };
}
