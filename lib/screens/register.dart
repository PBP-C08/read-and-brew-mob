import 'dart:convert';
import 'package:flutter/material.dart';
// TODO: Impor drawer yang sudah dibuat sebelumnya
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/login.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

const List<List<String>> list = <List<String>>[
  ["M", "Member"],
  ["E", "Employee"]
];

class _RegisterFormPageState extends State<RegisterFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _status = list.first.first;
  String _fullname = "";
  String _email = "";
  String _username = "";
  String _password = "";
  String _password2 = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Registrasi',
          ),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownMenu<String>(
              label: Text("Status"),
              initialSelection: list.first.first,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  _status = value!;
                });
              },
              dropdownMenuEntries:
                  list.map<DropdownMenuEntry<String>>((List value) {
                return DropdownMenuEntry<String>(
                    value: value.first, label: value.last);
              }).toList(),
              requestFocusOnTap: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Fullname",
                labelText: "Fullname",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _fullname = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Fullname tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Email",
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _email = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Email tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Username",
                labelText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _username = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Username tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              obscureText: true,
              onChanged: (String? value) {
                setState(() {
                  _password = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Password tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Konfirmasi Password",
                labelText: "Konfirmasi Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              obscureText: true,
              onChanged: (String? value) {
                setState(() {
                  _password2 = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Konfirmasi Password tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 31, 141, 29)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Kirim ke Django dan tunggu respons
                    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                    final response = await request.postJson(
                        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/auth/create-user-flutter/",
                        jsonEncode(<String, String>{
                          'status': _status,
                          'full_name': _fullname,
                          'email': _email,
                          'username': _username,
                          'password1': _password,
                          'password2': _password2,
                          // TODO: Sesuaikan field data sesuai dengan aplikasimu
                        }));
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Berhasil mendaftar!"),
                      ));
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['messages']),
                      ));
                    }
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
