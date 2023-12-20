import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:read_and_brew/screens/login.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({Key? key}) : super(key: key);

  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _judul = "";
  String _penulis = "";
  String _kategori = "";
  String _gambar = "";

  // Create controllers for text fields
  TextEditingController _judulController = TextEditingController();
  TextEditingController _penulisController = TextEditingController();
  TextEditingController _kategoriController = TextEditingController();
  TextEditingController _gambarController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _judulController.dispose();
    _penulisController.dispose();
    _kategoriController.dispose();
    _gambarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Request'),
        foregroundColor: Color(0xFF377C35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  hintText: "Judul Buku",
                  labelText: "Judul Buku",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _penulisController,
                decoration: InputDecoration(
                  hintText: "Penulis",
                  labelText: "Penulis",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _kategoriController,
                decoration: InputDecoration(
                  hintText: "Kategori",
                  labelText: "Kategori",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _kategori = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Kategori tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gambarController,
                decoration: InputDecoration(
                  hintText: "Gambar",
                  labelText: "Gambar",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
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
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await request.postJson(
                      "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/create_request_flutter",
                      jsonEncode(<String, String>{
                        "user": user_id.toString(),
                        "judul": _judul,
                        "kategori": _kategori,
                        "penulis": _penulis,
                        "gambar": _gambar,
                      }),
                    );

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil menambahkan request buku ${_judul}"),
                        ),
                      );

                      // Clear form values and reset text controllers
                      _formKey.currentState?.reset();
                      _judulController.clear();
                      _penulisController.clear();
                      _kategoriController.clear();
                      _gambarController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response['messages']),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
