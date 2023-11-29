// To parse this JSON data, do
//
//     final requestBuku = requestBukuFromJson(jsonString);

import 'dart:convert';

List<RequestBuku> requestBukuFromJson(String str) => List<RequestBuku>.from(json.decode(str).map((x) => RequestBuku.fromJson(x)));

String requestBukuToJson(List<RequestBuku> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestBuku {
    String model;
    int pk;
    Fields fields;

    RequestBuku({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory RequestBuku.fromJson(Map<String, dynamic> json) => RequestBuku(
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
    String gambar;
    String judul;
    String penulis;
    String kategori;
    int like;
    String status;

    Fields({
        required this.user,
        required this.gambar,
        required this.judul,
        required this.penulis,
        required this.kategori,
        required this.like,
        required this.status,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        gambar: json["Gambar"],
        judul: json["Judul"],
        penulis: json["Penulis"],
        kategori: json["Kategori"],
        like: json["Like"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "Gambar": gambar,
        "Judul": judul,
        "Penulis": penulis,
        "Kategori": kategori,
        "Like": like,
        "Status": status,
    };
}
