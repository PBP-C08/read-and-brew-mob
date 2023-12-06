import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/booktracker.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';

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
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
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
                    style: TextStyle(color: Color.fromARGB(255, 133, 67, 13)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return GridView.builder(
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
                            bookTracker: snapshot.data![index],
                            fetchBookDetails: (bookId) =>
                                fetchBookDetails(bookId)),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4.0,
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
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
                              // Access penulis and kategori from bookSnapshot.data.fields
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      bookSnapshot.data!.fields.gambar,
                                      fit: BoxFit
                                          .cover, // This will cover the card's width
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookSnapshot.data!.fields.judul,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          bookSnapshot.data!.fields.penulis,
                                          style:
                                              const TextStyle(fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          getStatusLabel(snapshot
                                              .data![index].fields.status),
                                          style:
                                              const TextStyle(fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis,
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
              );
            }
          }
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final BookTracker bookTracker;
  final Function(int) fetchBookDetails;

  const DetailPage({
    Key? key,
    required this.bookTracker,
    required this.fetchBookDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Tracker"),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: fetchBookDetails(bookTracker.fields.book),
          builder: (context, AsyncSnapshot<Buku> bookSnapshot) {
            if (bookSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (bookSnapshot.hasError) {
              return Center(child: Text('Error loading book details'));
            } else if (!bookSnapshot.hasData) {
              return Center(child: Text('No book details available'));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    bookSnapshot.data!.fields.gambar,
                    width: 100.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "${bookSnapshot.data!.fields.judul}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Penulis:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${bookSnapshot.data!.fields.penulis}"),
                  SizedBox(height: 10),
                  Text(
                    "Kategori:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${bookSnapshot.data!.fields.kategori}"),
                  SizedBox(height: 10),
                  Text(
                    "Status:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getStatusLabel(bookTracker.fields.status),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.brown, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Text(
                        'Back',
                        style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}