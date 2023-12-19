import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/bookrequest.dart';
import 'package:read_and_brew/screens/bookrequest_individual.dart';
import 'package:read_and_brew/screens/login.dart';

class RequestBottomNavigationBar extends StatefulWidget {
  final String userStatus;

  const RequestBottomNavigationBar({
    required this.userStatus,
  });

  @override
  _RequestBottomNavigationBarState createState() =>
      _RequestBottomNavigationBarState();
}

class _RequestBottomNavigationBarState
    extends State<RequestBottomNavigationBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _judul = "";
  String _penulis = "";
  String _kategori = "";
  String _gambar = "";
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return widget.userStatus == "M"
        ? BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.request_page),
                label: 'Your Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Request',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox),
                label: 'All Requests',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestBukuIndividualPage(),
                    ),
                  );
                  break;
                case 1:
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      content: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Positioned(
                            right: -40,
                            top: -40,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close),
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          Colors.green),
                                    ),
                                    child: const Text('Submit',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () async {
                                      if (_formKey.currentState!
                                          .validate()) {
                                        final response =
                                            await request.postJson(
                                                "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/create_request_flutter",
                                                jsonEncode(<String,
                                                    String>{
                                                  "user" : user_id.toString(),
                                                  "judul": _judul,
                                                  "kategori": _kategori,
                                                  "penulis": _penulis,
                                                  "gambar": _gambar,
                                                }));
                                        if (response['status'] ==
                                            'success') {
                                          ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                response['messages']),
                                          ));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RequestBukuIndividualPage()),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                response['messages']),
                                          ));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestBukuPage(),
                    ),
                  );
                  break;
              }
            },
          )
        : Container(); // Return an empty Container as a placeholder when userStatus is not "M"
  }
}
