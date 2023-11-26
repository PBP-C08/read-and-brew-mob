import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/booklist.dart';
import 'package:read_and_brew/screens/login.dart';

class BookDetailPage extends StatelessWidget {
  final int id;
  final String gambar;
  final String judul;
  final int rating;
  final String kategori;
  final String penulis;
  const BookDetailPage(this.id, this.gambar, this.judul, this.rating,
      this.kategori, this.penulis,
      {Key? key})
      : super(key: key); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(judul),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                gambar,
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
              child: RatingBar.builder(
                initialRating: rating.toDouble(),
                minRating: 0,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize:
                    40, // Adjust this value to change the size of the stars
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                ignoreGestures: true,
                onRatingUpdate: (double value) {},
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Kategori: ${kategori}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Penulis: ${penulis}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            if (user_status == "E") ...[
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.red,
                    ),
                  ),
                  onPressed: () async {
                    final response = await request.postJson(
                        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/delete-book-flutter/",
                        jsonEncode(<String, String>{
                          "id": id.toString(),
                          // TODO: Sesuaikan field data sesuai dengan aplikasimu
                        }));
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['messages']),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BooklistPage("", "", "", "")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['messages']),
                      ));
                    }
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
