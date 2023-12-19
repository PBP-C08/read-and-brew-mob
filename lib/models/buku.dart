// To parse this JSON data, do
//
//     final buku = bukuFromJson(jsonString);

import 'dart:convert';

List<Buku> bukuFromJson(String str) =>
    List<Buku>.from(json.decode(str).map((x) => Buku.fromJson(x)));

String bukuToJson(List<Buku> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Buku {
  Model model;
  int pk;
  Fields fields;

  Buku({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Buku.fromJson(Map<String, dynamic> json) => Buku(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };

  @override
  String toString() {
    return 'id: $pk, judul: ${fields.judul}, author: ${fields.penulis}, kategori: ${fields.kategori}';
  }
}

class Fields {
  String gambar;
  String judul;
  String penulis;
  String kategori;
  int rating;

  Fields({
    required this.gambar,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.rating,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        gambar: json["Gambar"],
        judul: json["Judul"],
        penulis: json["Penulis"],
        kategori: json["Kategori"],
        rating: json["Rating"],
      );

  Map<String, dynamic> toJson() => {
        "Gambar": gambar,
        "Judul": judul,
        "Penulis": penulis,
        "Kategori": kategori,
        "Rating": rating,
      };
}

enum Model { BOOKLIST_BUKU }

final modelValues = EnumValues({"booklist.buku": Model.BOOKLIST_BUKU});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
