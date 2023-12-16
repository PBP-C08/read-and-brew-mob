import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/login.dart';
import 'dart:convert' as convert;


class AddReview extends StatefulWidget {
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  Future<List<Buku>> bookHistory(request) async {
    var url = Uri.parse('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // Fetch borrowed books by the current user
    var borrowedBooksResponse = await http.get(
      Uri.parse('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/member/borrowed-history/'),
      headers: {"Content-Type": "application/json"},
    );
    var borrowedBooksData =
        jsonDecode(utf8.decode(borrowedBooksResponse.bodyBytes));
    List<int> borrowedBookIds = borrowedBooksData
        .where((book) => book['fields']['user'] == user_id)
        .map<int>((item) => item['fields']['book'] as int)
        .toList();

    List<Buku> list_item = [];

    for (var d in data) {
      var bookId = d['pk'];
      if (borrowedBookIds.contains(bookId)) {
        list_item.add(Buku.fromJson(d));
      }
    }
    return list_item;
  }
  final _formKey = GlobalKey<FormState>();

  String _selectedRating = "";
  
  TextEditingController _username = TextEditingController();
  TextEditingController _bookname = TextEditingController();
  TextEditingController _rating = TextEditingController();
  TextEditingController _review = TextEditingController();

  List<DropdownMenuItem<String>> dropDownItems = [];
  List<DropdownMenuItem<String>> dropDownRating = const [
    DropdownMenuItem(value: "1", child: Text("1")),
    DropdownMenuItem(value: "2", child: Text("2")),
    DropdownMenuItem(value: "3", child: Text("3")),
    DropdownMenuItem(value: "4", child: Text("4")),
    DropdownMenuItem(value: "5", child: Text("5")),
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    var screenSize = MediaQuery.of(context).size;

    _username.text = user_username;

    return Center(
        child: Material(
        // elevation: 8.0, // Adjust the elevation as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // color: Color(0xFF377C35),
        child: Padding(
        padding: const EdgeInsets.all(2.0),
        child:  Container(
           decoration: BoxDecoration(
            gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(
                  255, 235, 255, 235),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Color(0xFF377C35),
              width: 1,
            ),
            borderRadius:
                BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                // offset: Offset(4, 8),
                color: Colors.grey
              )
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
              width: screenSize.width * 0.9, // Sets the container width to 80% of the screen width
              child: SingleChildScrollView( // Allows for scrolling when keyboard is displayed
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the column's children vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center the column's children vertically
                    children: [
                      SizedBox(height: screenSize.height * 0.05), // This creates space at the top of the column
                      const Center(child: Text(
                          'Add a Review',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _username,
                          decoration: InputDecoration(
                            hintText: "Username",
                            labelText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: FutureBuilder(
                            future: bookHistory(request),
                            builder:
                                (context, AsyncSnapshot<List<Buku>> snapshot) {
                              if (snapshot.hasError) {
                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent))),
                                  items: dropDownItems,
                                  onChanged: (String? selected) {
                                    // Handle the selected item here
                                  },
                                  validator: (value) => value == null ? 'Need to borrow a book first!' : null,
                                  hint: const Text(
                                    "You Haven't Borrowed Any Books",
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                dropDownItems = snapshot.data!
                                    .map((item) => DropdownMenuItem(
                                          value: item.fields.judul,
                                          child: Text(item.fields.judul, overflow: TextOverflow.ellipsis),
                                        ))
                                    .toList();
                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent))),
                                  value: _bookname.text.isNotEmpty
                                      ? _bookname.text
                                      : null, // Set the selected item
                                  onChanged: (String? selected) {
                                    setState(() {
                                      _bookname.text = selected!;
                                      print(_bookname.text);
                                    });
                                  },
                                  validator: (value) => value == null ? 'Choose a book!' : null,
                                  hint: const Text(
                                    "~~Select Book~~",
                                  ),
                                  items: dropDownItems,
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent))),
                            value: _selectedRating.isEmpty ? null : _selectedRating,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedRating = value!;
                              });
                            },
                            validator: (value) => value == null ? 'Rate the book!' : null,
                            hint: const Text(
                              "~~Rate The Book~~",
                            ),
                            items: dropDownRating.map((item) {
                              return DropdownMenuItem<String>(
                                value: item.value,
                                child: Text(item.value.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Review",
                            labelText: "Review",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _review.text = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Fill out the blank review!";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 28.0),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF377C35)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Cek kredensial
                            // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                            // Untuk menyambungkan Android emulator dengan Django pada localhost,
                            // gunakan URL http://10.0.2.2/
                            final response = await request.postJson(
                                "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/add-review-flutter/",
                                convert.jsonEncode(<String, String>{
                                  'username': _username.text.toString(),
                                  'bookname': _bookname.text.toString(),
                                  'rating': _rating.text.toString(),
                                  'review': _review.text.toString(),
                                }));

                            if (response['status'] == 'success') {
                              if (!context.mounted) return;
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Review Submitted!"),
                                    content: const Text("Your review has been published"),
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
                              // if (!context.mounted) return;
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const LoginPage()),
                              // );
                            } else {
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Failed to submit'),
                                  content: Text(response['message']),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                            _formKey.currentState!.reset();
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.05)
                      // ElevatedButton(
                      //   onPressed: () {
                      //     if (!context.mounted) return;
                      //       Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const LoginPage()),
                      //       );
                      //   },
                      //   child: const Text('Back'),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      );
  }

}