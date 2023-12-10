import 'package:flutter/material.dart';
import 'package:read_and_brew/models/booktracker.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/tracker.dart';

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