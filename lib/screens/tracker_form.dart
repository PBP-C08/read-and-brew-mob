import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/tracker.dart';
import 'package:read_and_brew/models/booktracker.dart';
import 'package:read_and_brew/models/buku.dart';

class TrackerFormPage extends StatefulWidget {
  const TrackerFormPage({Key? key}) : super(key: key);

  @override
  State<TrackerFormPage> createState() => _TrackerFormPageState();
}

class _TrackerFormPageState extends State<TrackerFormPage> {
  final _formKey = GlobalKey<FormState>();
  int _page = 0;
  int _progress = 0;
  late List<Buku> _availableBooks;
  late String _selectedBookId;

  @override
  void initState() {
    super.initState();
    _availableBooks = [];
    _selectedBookId = ''; 
    _refreshBookTracker();
  }

  Future<List<BookTracker>> getTrackedBooks() async {
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

  Future<List<Buku>> getBooks() async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object BookTracker
    List<Buku> list_buku = [];
    for (var d in data) {
      if (d != null) {
        list_buku.add(Buku.fromJson(d));
      }
    }
    return list_buku;
  }

  Future<void> _refreshBookTracker() async {
    final books = await getBooks();
    final trackedBooks = await getTrackedBooks();

    setState(() { // Set the state after data is fetched
      _availableBooks = books.where((book) {
        final bookId = book.pk;
        final isInProgress = trackedBooks.any(
          (trackedBook) =>
              trackedBook.fields.book == bookId &&
              trackedBook.fields.status == 'in-progress',
        );
        return !isInProgress;
      }).toList();

      if (_availableBooks.isNotEmpty) {
        _selectedBookId = _availableBooks.first.pk.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Book'),
        foregroundColor: Color(0xFF377C35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Select Book',
                            labelText: 'Book Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          value: _selectedBookId,
                          items: _availableBooks.map((book) {
                            return DropdownMenuItem<String>(
                              value: book.pk.toString(),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  book.fields.judul,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedBookId = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please select a book';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Total Book Pages',
                      labelText: 'Total Book Pages',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _page = int.parse(value!);
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Book pages cannot be empty!';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Book pages must be an integer!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Total Pages Read',
                      labelText: 'Total Pages Read',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _progress = int.parse(value!);
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Book progress cannot be empty!';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Book progress must be an integer!';
                      }
                      return null;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 160,
                    height: 70, // Set the width here
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF377C35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _addTracker(request);
                          }
                        },
                        child: const Text(
                          'Track Book',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addTracker(CookieRequest request) async {
    try {
      final formData = <String, dynamic>{
        'book': _selectedBookId,
        'page': _page,
        'progress': _progress,
        'status': (_page == _progress) ? 'finished' : 'in-progress',
      };

      final response = await request.postJson(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/trackernplanner/track-book-guest-flutter',
        jsonEncode(formData),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have successfully tracked your book!'),
          ),
        );
        await _refreshBookTracker();
        _formKey.currentState?.reset();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookTrackerPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      print('An error occurred: $e'); // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}