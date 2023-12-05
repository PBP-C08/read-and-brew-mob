// To parse this JSON data, do
//
//     final bookTracker = bookTrackerFromJson(jsonString);

import 'dart:convert';

List<BookTracker> bookTrackerFromJson(String str) => List<BookTracker>.from(json.decode(str).map((x) => BookTracker.fromJson(x)));

String bookTrackerToJson(List<BookTracker> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookTracker {
    String model;
    int pk;
    Fields fields;

    BookTracker({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory BookTracker.fromJson(Map<String, dynamic> json) => BookTracker(
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
    int page;
    int progress;
    String status;

    Fields({
        required this.book,
        required this.page,
        required this.progress,
        required this.status,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        page: json["page"],
        progress: json["progress"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "page": page,
        "progress": progress,
        "status": status,
    };
}