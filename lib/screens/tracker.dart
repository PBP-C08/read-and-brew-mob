//TODO: figure out import book detail dari Django
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/booktracker.dart';
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Book Tracker'),
      backgroundColor: Colors.indigo,
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
            return const Column(
              children: [
                Text(
                  "You haven't tracked any books.",
                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                ),
                SizedBox(height: 8),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(bookTracker: snapshot.data![index]),
                    ),
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getStatusLabel(snapshot.data![index].fields.status),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // Text("${snapshot.data![index].fields.penulis}"),
                      // const SizedBox(height: 10),
                      // Text("${snapshot.data![index].fields.kategori}")
                    ],
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

  const DetailPage({Key? key, required this.bookTracker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(
            //   bookTracker.fields.gambar, // Replace this with your image URL
            //   width: 100.0, // Adjust the width as needed
            //   height: 200.0, // Adjust the height as needed
            //   fit: BoxFit.cover, // You can adjust the fit property based on your needs
            // ),
            // Text(
            //   "${bookTracker.fields.judul}",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10),
            // Text(
            //   "Penulis:",
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text("${bookTracker.fields.penulis}"),
            // SizedBox(height: 10),
            // Text(
            //   "Kategori:",
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text("${bookTracker.fields.kategori}"),
            // SizedBox(height: 10),
            Text(
              "Status:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              getStatusLabel(bookTracker.fields.status),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen (R)
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Set button shape to rectangle
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust padding for a smaller button
                child: Text(
                  'Back',
                  style: TextStyle(fontSize: 14, color: Colors.white), // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}