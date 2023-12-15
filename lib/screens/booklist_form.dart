import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/booklist.dart';

class BooklistFormPage extends StatefulWidget {
  final List<String> list_kategori;
  const BooklistFormPage(this.list_kategori, {super.key});

  @override
  State<BooklistFormPage> createState() => _BooklistFormPageState();
}

const List<List<String>> list = <List<String>>[
  ["M", "Member"],
  ["E", "Employee"]
];

class _BooklistFormPageState extends State<BooklistFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _kategori = "";
  String _gambar = "";
  String _judul = "";
  String _penulis = "";

  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 23, bottom: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        child: Text(
                      'Add Book',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0.03,
                      ),
                    )),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Gambar",
                                  labelText: "Gambar",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _gambar = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Gambar tidak boleh kosong!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Judul",
                                  labelText: "Judul",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _judul = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Judul tidak boleh kosong!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Column(
                                children: [
                                  Autocomplete(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      }
                                      return widget.list_kategori
                                          .where((String option) {
                                        return option.contains(textEditingValue
                                            .text
                                            .toLowerCase());
                                      });
                                    },
                                    onSelected: (selectedString) {
                                      _kategori = selectedString;
                                    },
                                    fieldViewBuilder: (context, controller,
                                        focusNode, onEditingComplete) {
                                      this.controller = controller;

                                      return TextFormField(
                                        controller: controller,
                                        focusNode: focusNode,
                                        onEditingComplete: onEditingComplete,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _kategori = value!;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Kategori",
                                          labelText: "Kategori",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "Kategori tidak boleh kosong!";
                                          }
                                          return null;
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Penulis",
                                  labelText: "Penulis",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _penulis = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Penulis tidak boleh kosong!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF377C35)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final response = await request.postJson(
                                        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/create-book-flutter/",
                                        jsonEncode(<String, String>{
                                          "judul": _judul,
                                          "kategori": _kategori,
                                          "penulis": _penulis,
                                          "gambar": _gambar,
                                        }));
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(response['messages']),
                                      ));
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BooklistPage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(response['messages']),
                                      ));
                                    }
                                  }
                                },
                                child: const Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ])),
                    ),
                  ],
                ))));
  }
}
