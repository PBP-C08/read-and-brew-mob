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
  bool _obscureText = true;
  bool _obscureText2 = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
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
                      'Register',
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
                              child: DropdownMenu<String>(
                                inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width -
                                    50, // Lebarnya dropdown
                                label: Text("Role"),

                                initialSelection: list.first.first,
                                onSelected: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    _status = value!;
                                  });
                                },
                                dropdownMenuEntries: list
                                    .map<DropdownMenuEntry<String>>(
                                        (List value) {
                                  return DropdownMenuEntry<String>(
                                      value: value.first, label: value.last);
                                }).toList(),
                                requestFocusOnTap: false,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Fullname",
                                  labelText: "Fullname",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
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
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
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
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  labelText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
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
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Choose the icon based on password visibility
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                ),
                                obscureText: _obscureText,
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
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Konfirmasi Password",
                                  labelText: "Konfirmasi Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Choose the icon based on password visibility
                                      _obscureText2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: _togglePasswordVisibility2,
                                  ),
                                ),
                                obscureText: _obscureText2,
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Berhasil mendaftar!"),
                                      ));
                                      Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
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
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?"),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Color(0xFF377C35),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])),
                    ),
                  ],
                ))));
  }
}
