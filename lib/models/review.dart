// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
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
    String username;
    String bookName;
    int rating;
    String review;

    Fields({
        required this.user,
        required this.username,
        required this.bookName,
        required this.rating,
        required this.review,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        username: json["username"],
        bookName: json["book_name"],
        rating: json["rating"],
        review: json["review"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "username": username,
        "book_name": bookName,
        "rating": rating,
        "review": review,
    };
}
