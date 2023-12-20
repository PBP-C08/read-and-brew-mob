// request_buku_individual_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:read_and_brew/models/requestbuku.dart';
import 'package:read_and_brew/screens/bookrequest_individual_detail.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/screens/login.dart';

class RequestBukuIndividualPage extends StatefulWidget {
  const RequestBukuIndividualPage({Key? key}) : super(key: key);

  @override
  _RequestBukuIndividualPageState createState() =>
      _RequestBukuIndividualPageState();
}

class _RequestBukuIndividualPageState
    extends State<RequestBukuIndividualPage> {
  Future<List<RequestBuku>> fetchProduct() async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/get_books_individual_flutter');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id': user_id.toString()}),
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<RequestBuku> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(RequestBuku.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Color(0xFF377C35),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum ada request buku.",
                      style:
                          TextStyle(color: Color(0xFF377C35), fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: (1 / 1.5),
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualDetailPage(
                            requestBuku: snapshot.data![index],
                            onRefresh: () {
                              setState(() {}); // Refresh the page
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: snapshot.data![index].fields.status !=
                                    "Approved"
                                ? Color.fromARGB(255, 118, 124, 53)
                                : Color(0xFF377C35),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1.0,
                      color: snapshot.data![index].fields.status != "Approved"
                          ? Color.fromARGB(255, 235, 227, 162)
                          : const Color.fromARGB(255, 235, 255, 235),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data![index].fields.status,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 27, 68, 26),
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Image.network(
                                snapshot.data![index].fields.gambar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.error,
                                    size: 100.0,
                                    color: Colors.red,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data![index].fields.judul,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    snapshot.data![index].fields.penulis,
                                    style: TextStyle(fontSize: 16.0),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.thumb_up,
                                        color: Color.fromARGB(255, 1, 97, 16),
                                        size: 18.0,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        snapshot.data![index]
                                            .fields
                                            .like
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
