import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:read_and_brew/models/booktracker.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/tracker_form.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/screens/tracker_detail.dart';

String getStatusLabel(String status) {
  switch (status) {
    case 'in-progress':
      return 'In Progress';
    case 'finished':
      return 'Finished';
    default:
      return 'Unknown Status';
  }
}

class BookTrackerPage extends StatefulWidget {
  const BookTrackerPage({Key? key}) : super(key: key);

  @override
  _BookTrackerPageState createState() => _BookTrackerPageState();
}

class _BookTrackerPageState extends State<BookTrackerPage> {
  Future<List<BookTracker>> fetchBook() async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/trackernplanner/show-json-tracker');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object BookTracker
    List<BookTracker> list_book_tracker = [];
    for (var d in data) {
      if (d != null) {
        list_book_tracker.add(BookTracker.fromJson(d));
      }
    }
    return list_book_tracker;
  }

  Future<Buku> fetchBookDetails(int bookId) async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // find the book with the desired ID
    var bookData =
        data.firstWhere((book) => book['pk'] == bookId, orElse: () => null);

    if (bookData != null) {
      return Buku.fromJson(bookData);
    } else {
      throw Exception('Book not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tracker'),
        foregroundColor: Color(0xFF377C35),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchBook(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    "You haven't tracked any books.",
                    style: TextStyle(color: Color(0xFF377C35)),
                  ),
                  SizedBox(height: 8),
                ],
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            fetchBookDetails: fetchBookDetails,
                            bookTracker: snapshot.data![index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: IntrinsicHeight(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          child: FutureBuilder(
                            future: fetchBookDetails(
                                snapshot.data![index].fields.book),
                            builder: (context, AsyncSnapshot<Buku> bookSnapshot) {
                              if (bookSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (bookSnapshot.hasError) {
                                return Text('Error loading book details');
                              } else if (!bookSnapshot.hasData) {
                                return Text('No book details available');
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        bookSnapshot.data!.fields.gambar,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center, 
                                        children: [
                                          Text(
                                            bookSnapshot.data!.fields.judul,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center, 
                                          ),
                                          Text(
                                            bookSnapshot.data!.fields.penulis,
                                            style: const TextStyle(fontSize: 16.0),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            getStatusLabel(snapshot
                                                .data![index].fields.status),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF472B26)
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
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
      floatingActionButton: Container(
        height: 70.0, // Increase the height
        width: 70.0, // Increase the width
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackerFormPage(),
                ),
              );
            },
            tooltip: 'Track Book', // Add this line
            backgroundColor: Color(0xFF377C35),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}