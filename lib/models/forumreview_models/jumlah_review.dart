// To parse this JSON data, do
//
//     final jumlahReview = jumlahReviewFromJson(jsonString);

import 'dart:convert';

List<JumlahReview> jumlahReviewFromJson(String str) => List<JumlahReview>.from(json.decode(str).map((x) => JumlahReview.fromJson(x)));

String jumlahReviewToJson(List<JumlahReview> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JumlahReview {
    String model;
    int pk;
    Fields fields;

    JumlahReview({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory JumlahReview.fromJson(Map<String, dynamic> json) => JumlahReview(
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
    int book;
    int jumlah;

    Fields({
        required this.book,
        required this.jumlah,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        jumlah: json["jumlah"],
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "jumlah": jumlah,
    };
}
