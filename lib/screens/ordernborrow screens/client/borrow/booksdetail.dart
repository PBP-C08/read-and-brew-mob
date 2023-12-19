// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrowpage.dart';

class BooksDetails extends StatefulWidget {
  final int id;
  final String gambar;
  final String judul;
  final int rating;
  final String kategori;
  final String penulis;
  final String fromBorrowedHistory;

  const BooksDetails(this.id, this.gambar, this.judul, this.rating,
      this.kategori, this.penulis, this.fromBorrowedHistory,
      {Key? key})
      : super(key: key);

  @override
  _BooksDetailsState createState() => _BooksDetailsState();
}

class _BooksDetailsState extends State<BooksDetails> {
  late Future<bool> isBorrowedFuture;

  @override
  void initState() {
    super.initState();
    isBorrowedFuture = isBookBorrowed();
  }

  Future<bool> isBookBorrowed() async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/member/borrowed/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    bool isBorrowed = false;

    for (var d in data) {
      if (d != null &&
          d['fields']['user'] == user_id &&
          d['fields']['book'] == widget.id) {
        isBorrowed = true;
      }
    }
    return isBorrowed;
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String action, String bookTitle) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm $action"),
          content: Text("Are you sure you want to $action \"$bookTitle\" ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.judul,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        foregroundColor: const Color(0xFF377C35),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.gambar,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Icon(Icons.error);
                },
                width: 200,
                height: 300,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: RatingBar.builder(
                initialRating: widget.rating.toDouble(),
                minRating: 0,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 40,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                ignoreGestures: true,
                onRatingUpdate: (double value) {},
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Category: ${widget.kategori}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Author: ${widget.penulis}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (widget.fromBorrowedHistory == "NO") ...[
              FutureBuilder<bool>(
                future: isBorrowedFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    bool isBorrowed = snapshot.data ?? false;
                    return Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            isBorrowed ? Colors.red : Colors.green,
                          ),
                        ),
                        onPressed: isBorrowed
                            ? () async {
                                bool confirmed = await _showConfirmationDialog(
                                    context, "return", widget.judul);
                                if (confirmed) {
                                  int id = widget.id;
                                  String judul = widget.judul;
                                  final response = await request.postJson(
                                    "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/member/return-book-flutter/",
                                    jsonEncode(<String, String>{
                                      "id": id.toString(),
                                    }),
                                  );
                                  if (response['status'] == 'success') {
                                    indexBorrow = 2;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BorrowPage(),
                                      ),
                                    );
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Returned Successfully!"),
                                          content: Text(
                                              "You have returned \"${judul}\" !"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(response['messages']),
                                    ));
                                  }
                                }
                              }
                            : () async {
                                bool confirmed = await _showConfirmationDialog(
                                    context, "borrow", widget.judul);
                                if (confirmed) {
                                  int id = widget.id;
                                  String judul = widget.judul;
                                  final response = await request.postJson(
                                    "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/member/borrow-book-flutter/",
                                    jsonEncode(<String, String>{
                                      "id": id.toString(),
                                    }),
                                  );
                                  if (response['status'] == 'success') {
                                    indexBorrow = 1;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BorrowPage(),
                                      ),
                                    );
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Borrowed Successfully!"),
                                          content: Text(
                                              "You have borrowed \"$judul\" !"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(response['messages']),
                                    ));
                                  }
                                }
                              },
                        child: Text(
                          isBorrowed ? 'Return' : 'Borrow',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              )
            ]
          ],
        ),
      ),
    );
  }
}
