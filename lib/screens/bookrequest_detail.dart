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
            Image.network(
              requestBuku.fields.gambar, // Replace this with your image URL
              width: 100.0, // Adjust the width as needed
              height: 200.0, // Adjust the height as needed
              fit: BoxFit.cover, // You can adjust the fit property based on your needs
            ),
            Text(
              "${requestBuku.fields.judul}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Penulis:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${requestBuku.fields.penulis}"),
            SizedBox(height: 10),
            Text(
              "Kategori:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${requestBuku.fields.kategori}"),
            SizedBox(height: 10),
            Text(
              "Like:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${requestBuku.fields.like}"),
            SizedBox(height: 10),
            Text(
              "Status:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${requestBuku.fields.status}"),
            SizedBox(height: 16),
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
