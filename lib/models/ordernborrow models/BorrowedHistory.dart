// To parse this JSON data, do
//
//     final borrowedHistory = borrowedHistoryFromJson(jsonString);

import 'dart:convert';

List<BorrowedHistory> borrowedHistoryFromJson(String str) => List<BorrowedHistory>.from(json.decode(str).map((x) => BorrowedHistory.fromJson(x)));

String borrowedHistoryToJson(List<BorrowedHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BorrowedHistory {
    Model model;
    int pk;
    Fields fields;

    BorrowedHistory({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory BorrowedHistory.fromJson(Map<String, dynamic> json) => BorrowedHistory(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    int book;

    Fields({
        required this.user,
        required this.book,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
    };
}

enum Model {
    ORDERNBORROW_BORROWEDHISTORY
}

final modelValues = EnumValues({
    "ordernborrow.borrowedhistory": Model.ORDERNBORROW_BORROWEDHISTORY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
