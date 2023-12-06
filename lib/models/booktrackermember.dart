// To parse this JSON data, do
//
//     final bookTrackerMember = bookTrackerMemberFromJson(jsonString);

import 'dart:convert';

List<BookTrackerMember> bookTrackerMemberFromJson(String str) => List<BookTrackerMember>.from(json.decode(str).map((x) => BookTrackerMember.fromJson(x)));

String bookTrackerMemberToJson(List<BookTrackerMember> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookTrackerMember {
    String model;
    int pk;
    Fields fields;

    BookTrackerMember({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory BookTrackerMember.fromJson(Map<String, dynamic> json) => BookTrackerMember(
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
    int book;
    int page;
    int progress;
    String status;

    Fields({
        required this.user,
        required this.book,
        required this.page,
        required this.progress,
        required this.status,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
        page: json["page"],
        progress: json["progress"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
        "page": page,
        "progress": progress,
        "status": status,
    };
}
