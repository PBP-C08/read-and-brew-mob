import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/booktracker.dart';
import 'package:read_and_brew/models/booktrackermember.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/tracker.dart';
import 'package:read_and_brew/screens/login.dart';

class DetailPage extends StatefulWidget {
  final BookTracker? bookTracker;
  final BookTrackerMember? bookTrackerMember;
  final Function(int) fetchBookDetails;

  const DetailPage({
    Key? key,
    this.bookTracker,
    this.bookTrackerMember,
    required this.fetchBookDetails,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  int _bookId = 0;
  int _bookDetailsId = 0;
  late int _progress;
  late int _page;
  late String _status;
  late int _formProgress;

  @override
  void initState() {
    super.initState();
    _progress = widget.bookTrackerMember != null
        ? widget.bookTrackerMember!.fields.progress
        : widget.bookTracker!.fields.progress;
    _page = widget.bookTrackerMember != null
        ? widget.bookTrackerMember!.fields.page
        : widget.bookTracker!.fields.page;
    _status = widget.bookTrackerMember != null
        ? getStatusLabel(widget.bookTrackerMember!.fields.status)
        : getStatusLabel(widget.bookTracker!.fields.status);
    _formProgress = _progress;
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
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Color(0xFF377C35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: widget.bookTrackerMember != null
            ? fetchBookDetails(widget.bookTrackerMember!.fields.book)
            : fetchBookDetails(widget.bookTracker!.fields.book),
          builder: (context, AsyncSnapshot<Buku> bookSnapshot) {
            if (bookSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (bookSnapshot.hasError) {
              return Center(child: Text('Error loading book details'));
            } else if (!bookSnapshot.hasData) {
              return Center(child: Text('No book details available'));
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        child: Transform.scale(
                          scale: 0.85,
                          child: Image.network(
                            bookSnapshot.data!.fields.gambar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '${bookSnapshot.data!.fields.judul}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        '${bookSnapshot.data!.fields.penulis}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Status: ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$_status',
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
                          text: 'Pages Read: ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$_progress/$_page',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 165,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFE8F5E9),
                                  title: const Text(
                                    "Edit Your Progress",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF377C35)),
                                  ),
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: 'Total Pages Read',
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (String? value) {
                                            if (value != null && value.isNotEmpty) {
                                              try {
                                                _formProgress = int.parse(value);
                                              } catch (e) {
                                                // Handle the exception. For example, you can show a message to the user.
                                                print('Invalid number: $value');
                                              }
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Book progress invalid!";
                                            }
                                            if (int.tryParse(value) == null) {
                                              return "Book progress invalid!";
                                            }
                                            int enteredPages =
                                                int.tryParse(value) ?? 0;
                                            if (enteredPages < 1) {
                                              return "Book progress must be positive!";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _formKey.currentState!.reset();
                                      },
                                      child: const Text('Cancel'),
                                      style: TextButton.styleFrom(
                                        primary: Color(0xFF377C35),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _bookId =
                                              widget.bookTrackerMember != null
                                                  ? widget.bookTrackerMember!
                                                      .fields.book
                                                  : widget
                                                      .bookTracker!.fields.book;
                                          _bookDetailsId =
                                              bookSnapshot.data!.pk;
                                          _editProgress(request, _formProgress, _bookId, _bookDetailsId);
                                          _formKey.currentState!.reset();
                                        }
                                      },
                                      child: const Text('Save'),
                                      style: TextButton.styleFrom(
                                        primary: Color(0xFF377C35),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF377C35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Text(
                              'Edit Progress',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    user_status != 'M' ? SizedBox(height: 24) : Container(),
                    user_status == 'M'
                      ? Column(
                          children: [
                            SizedBox(height: 13),
                            Center(
                              child: Container(
                                width: 165,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _bookId =
                                        widget.bookTrackerMember != null
                                            ? widget.bookTrackerMember!
                                                .fields.book
                                            : widget
                                                .bookTracker!.fields.book;
                                    _bookDetailsId =
                                        bookSnapshot.data!.pk;
                                    _deleteProgress(request, _bookId, _bookDetailsId);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24), // Add this line to create a gap
                          ],
                        )
                      : Container(), // Empty container when user_status is not 'M'
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _editProgress(CookieRequest request, int _progress, int _bookId, int _bookDetailId) async {
    final response;
    
    if (user_status == 'M') {
      response = await request.postJson(
          "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/trackernplanner/update-progress-member-flutter/$_bookId",
          jsonEncode(<String, String>{
            'progress': _progress.toString(),
          }));
    } else {
      response = await request.postJson(
          "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/trackernplanner/update-progress-flutter/$_bookId",
          jsonEncode(<String, String>{
            'progress': _progress.toString(),
          }));
    }

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have successfully edited your progress!"),
      ));
      this._progress = _progress;
      this._page = _page; 


      if (_progress == _page) {
        this._status = 'Finished';
      } else {
        this._status = 'In Progress';
      }

      setState(() {});
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred. Please try again later."),
      ));
      Navigator.pop(context);
    }
  }

   Future<void> _deleteProgress(CookieRequest request, int _bookId, int _bookDetailId) async {
    final response = await request.postJson(
          "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/trackernplanner/delete-book-member-flutter",
          jsonEncode(<String, String>{
            'id': _bookId.toString(),
          }));

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have successfully deleted your progress!"),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred. Please try again later."),
      ));
      Navigator.pop(context);
    }
  }
}