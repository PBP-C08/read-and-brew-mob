import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/requestbuku.dart';
import 'package:read_and_brew/screens/booklist_detail.dart';
import 'package:read_and_brew/screens/bookrequest.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/screens/login.dart';

class DetailPage extends StatelessWidget {
  final RequestBuku requestBuku;

  const DetailPage({Key? key, required this.requestBuku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(requestBuku.fields.judul),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                requestBuku.fields.gambar,
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
              child: Text(
                'Kategori: ${requestBuku.fields.kategori}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Penulis: ${requestBuku.fields.penulis}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            if (user_status == "E") ...[
            ElevatedButton(
              onPressed: () async {
                    final response = await request.postJson(
                        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/delete_request_flutter/",
                        jsonEncode(<String, String>{
                          "id": requestBuku.pk.toString(),
                          // TODO: Sesuaikan field data sesuai dengan aplikasimu
                        }));
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Berhasil menghapus buku ${requestBuku.fields.judul}"),
                      ));
                      Navigator.pop(context); // Balik ke bookrequest
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Gagal menghapus buku ${requestBuku.fields.judul}"),
                      ));
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
            ElevatedButton(
              onPressed: () async {
                    final response = await request.postJson(
                        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/approve_request_flutter/",
                        jsonEncode(<String, String>{
                          "id": requestBuku.pk.toString(),
                          // TODO: Sesuaikan field data sesuai dengan aplikasimu
                        }));
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Berhasil approve buku ${requestBuku.fields.judul}"),
                      ));
                      Navigator.pop(context); // Balik ke bookrequest
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Gagal approve buku ${requestBuku.fields.judul}"),
                      ));
                    }
                  },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  'Approve',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            ]
            else if (user_status == 'M')...[
              ElevatedButton(
              onPressed: () async {
                    final response = await request.postJson(
                        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/like_request_flutter/",
                        jsonEncode(<String, String>{
                          "id": requestBuku.pk.toString(),
                          // TODO: Sesuaikan field data sesuai dengan aplikasimu
                        }));
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Berhasil menyukai buku ${requestBuku.fields.judul}"),
                      ));
                      Navigator.pop(context); // Balik ke bookrequest
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Gagal menyukai buku ${requestBuku.fields.judul}"),
                      ));
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
            ]
          ],
        ),
      ),
    );
  }
}