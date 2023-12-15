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

  int index_rating = 0;
  int index_item = 0;
  

  TextEditingController _username = TextEditingController();
  TextEditingController _bookname = TextEditingController();
  TextEditingController _rating = TextEditingController();
  TextEditingController _review = TextEditingController();

  // String _username = "";
  // String _bookname = "";
  // String _rating = "";
  // String _review = "";

  // String dropDownValue = "";
  // String rating = "";
  List<DropdownMenuItem<String>> dropDownItems = [];
  List<DropdownMenuItem<String>> dropDownRating = [
    DropdownMenuItem(
        value: "~~Rate The Book~~", child: Text("~~Rate The Book~~")),
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
        child: Card(
        elevation: 8.0, // Adjust the elevation as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // color: Color(0xFF377C35),
        child: Padding(
        padding: EdgeInsets.all(18.0),
        child:  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Container(
              width: screenSize.width * 0.9, // Sets the container width to 80% of the screen width
              child: SingleChildScrollView( // Allows for scrolling when keyboard is displayed
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the column's children vertically
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Center the column's children vertically
                    children: [
                      SizedBox(height: screenSize.height * 0.1), // This creates space at the top of the column
                      Center(child: Text(
                          'Add a Review',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                        SizedBox(height: 20),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: FutureBuilder(
                            future: bookHistory(request),
                            builder:
                                (context, AsyncSnapshot<List<Buku>> snapshot) {
                              if (snapshot.hasError) {
                                return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent))),
                                  items: dropDownItems,
                                  onChanged: (String? selected) {
                                    // Handle the selected item here
                                  },
                                  validator: (value) => value == null ? 'Need to borrow a book first!' : null,
                                  hint: Text(
                                    "You Haven't Borrowed Any Books",
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                dropDownItems = snapshot.data!
                                    .map((item) => DropdownMenuItem(
                                          value: item.fields.judul,
                                          child: Text(item.fields.judul),
                                        ))
                                    .toList();
                                return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
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
                                  hint: Text(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent))),
                            value: dropDownRating[index_rating].value,
                            onChanged: (String? value) {
                              setState(() {
                                if (value == "~~Rate The Book~~") {
                                  index_rating = 0;
                                } else {
                                  index_rating = int.tryParse(value!)!;
                                }

                                if (value != "~~Rate The Book~~") {
                                  _rating.text = value!;
                                } else {
                                  _rating.text = "";
                                }
                              });
                            },
                            validator: (value) => value == "~~Rate The Book~~" ? 'Rate the book!' : null,
                            hint: Text(
                              "Rate The Book",
                              style: TextStyle(color: Colors.blue),
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
                      const SizedBox(height: 24.0),
                      // SizedBox(height: 20), // Space between last input field and the submit button
                      // Your ElevatedButton for submitting the form
                      // SizedBox(height: screenSize.height * 0.1), // This creates space at the bottom of the column
                      ElevatedButton(
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
                              // if (!context.mounted) return;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Your review is successfully submitted!"),
                              ));
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
                        child: const Text('Submit'),
                      ),
                      SizedBox(height: screenSize.height * 0.1)
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