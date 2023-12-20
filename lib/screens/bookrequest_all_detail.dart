import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/requestbuku.dart';
import 'package:read_and_brew/screens/bookrequest_all.dart';
import 'package:read_and_brew/screens/login.dart';
import 'dart:convert' as convert;

class DetailPage extends StatefulWidget {
  final RequestBuku requestBuku;

  const DetailPage({Key? key, required this.requestBuku}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Buku",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Color(0xFF377C35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Center(
              child: Text(
                widget.requestBuku.fields.judul,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Center(
              child: Image.network(
                widget.requestBuku.fields.gambar,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // You can return any widget here. For example, let's return an Icon.
                  return Icon(Icons.error);
                },
                width: 200,
                height: 300,
              ),
            ),
            SizedBox(height: 8),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Kategori: ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.requestBuku.fields.kategori,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 8),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Penulis: ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: widget.requestBuku.fields.penulis,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            Center(
              child: Row(
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
                    widget.requestBuku.fields.like.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ),
            SizedBox(height: 8),
            if (user_status == 'M')...[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Add this line
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final response = await request.postJson(
                          "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/like_request_flutter",
                          convert.jsonEncode(<String, String>{
                            'id': widget.requestBuku.pk.toString()
                          }),
                        );
                        if (response['status'] == 'success') {
                          setState(() {
                            widget.requestBuku.fields.like++; // Update the like value
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Berhasil menyukai request buku ${widget.requestBuku.fields.judul}",
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Gagal menyukairequest buku ${widget.requestBuku.fields.judul}",
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          'Like',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
            else if (user_status == 'E')...[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Add this line
                  children: [
                    ElevatedButton(
                      onPressed: widget.requestBuku.fields.status == 'Approved' ? null : () async {
                        final response = await request.postJson(
                          "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/approve_request_flutter",
                          jsonEncode(<String, String>{
                            "id": widget.requestBuku.pk.toString(),
                            // TODO: Sesuaikan field data sesuai dengan aplikasimu
                          }),
                        );
                        if (response['status'] == 'success') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestBukuAllPage()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Berhasil approve request buku ${widget.requestBuku.fields.judul}",
                              ),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestBukuAllPage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Gagal approve request buku ${widget.requestBuku.fields.judul}",
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: widget.requestBuku.fields.status == 'Approved' ? Colors.grey : Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          widget.requestBuku.fields.status == 'Approved' ? 'Approved' : 'Approve',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final response = await request.postJson(
                          "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/delete_request_flutter",
                          jsonEncode(<String, String>{
                            "id": widget.requestBuku.pk.toString(),
                            // TODO: Sesuaikan field data sesuai dengan aplikasimu
                          }),
                        );
                        if (response['status'] == 'success') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestBukuAllPage()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Berhasil menghapus request buku ${widget.requestBuku.fields.judul}",
                              ),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestBukuAllPage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Gagal menghapus request buku ${widget.requestBuku.fields.judul}",
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}