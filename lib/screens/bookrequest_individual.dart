import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/requestbuku.dart';
import 'package:read_and_brew/screens/bookrequest.dart';
import 'package:read_and_brew/screens/bookrequest_individual_detail.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/screens/login.dart';

class RequestBukuIndividualPage extends StatefulWidget {
    const RequestBukuIndividualPage({Key? key}) : super(key: key);

    @override
    _RequestBukuIndividualPageState createState() => _RequestBukuIndividualPageState();
}

class _RequestBukuIndividualPageState extends State<RequestBukuIndividualPage> {
final _formKey = GlobalKey<FormState>();
String _judul = "";
String _kategori = "";
String _penulis = "";
String _gambar = "";
Future<List<RequestBuku>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/get_books_individual_flutter');
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({ 'id': user_id.toString() }),
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<RequestBuku> list_product = [];
    for (var d in data) {
        if (d != null ) {
            list_product.add(RequestBuku.fromJson(d));
        }
    }
    return list_product;
}

@override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Requests'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Belum ada request buku.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => ListTile(
                      leading: Image.network(
                        snapshot.data![index].fields.gambar,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // You can return any widget here. For example, let's return an Icon.
                          return Icon(Icons.error);
                        },
                      ),
                      title: Text(snapshot.data![index].fields.judul),
                      subtitle: Text(snapshot.data![index].fields.kategori),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            IndividualDetailPage(requestBuku: snapshot.data![index]),
                          ),
                        );
                      },
                    ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: user_status == "M"
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                  child: Text('Your Requests'), // Add the required 'child' argument
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestBukuIndividualPage()),
                    );
                  },
                ),
                     ElevatedButton(
                          onPressed: () async {
                      await showDialog<void>(
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _judul = value!;
                                                });
                                              },
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _penulis = value!;
                                                });
                                              },
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _kategori = value!;
                                                });
                                              },
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _gambar = value!;
                                                });
                                              },
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              child: const Text('Submit',
                                                  style: TextStyle(
                                                      color: Colors.white)),
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
                                                            // TODO: Sesuaikan field data sesuai dengan aplikasimu
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
                              ));
                    },
                    child: Text('Add Request',
                        style: TextStyle(color: Colors.blue))),
                ElevatedButton(
                  child: Text('All Requests'), // Add the required 'child' argument
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestBukuPage()),
                    );
                  },
                ),
                  ]
            )
            )
            : null);
  }
}