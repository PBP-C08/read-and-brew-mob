import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/models/review.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;
// import 'package:read_and_brew/models/ordernborrow models/BorrowedHistory.dart';
// import 'package:read_and_brew/screens/booklist.dart';
import 'dart:convert' as convert;


class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {

  Future<List<Review>> fetchAllReview(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
    var data = await request.get(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review/');
    // melakukan konversi data json menjadi object Review
    List<Review> listAllReview = [];
    for (var d in data) {
      if (d != null) {
        listAllReview.add(Review.fromJson(d));
      }
    }
    return listAllReview;
  }

  Future<List<Review>> fetchMyReview(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
    var data = await request.get(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review-member/');
    // melakukan konversi data json menjadi object Review
    List<Review> listMyReview = [];
    for (var d in data) {
      if (d != null) {
        listMyReview.add(Review.fromJson(d));
      }
    }

    return listMyReview;
  }
  
  Future<List<Buku>> bookHistory(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
  
    var data = await request.get(
      'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get_borrowed_history_json_member'
    );

    // var dataDecoded = convert.json.decode(data.body);

    var books = await request.get(
      'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/'
    );

    // var booksDecoded = convert.json.decode(books.body);

    List<int> borrowedBookIds = data
        .where((book) => book['fields']['user'] == user_id)
        .map<int>((item) => item['fields']['book'] as int)
        .toList();

    // melakukan konversi data json menjadi object Review
    List<Buku> listBookHistory = [];
    for (var d in books) {
      var bookId = d['pk'];
      if (borrowedBookIds.contains(bookId)) {
        listBookHistory.add(Buku.fromJson(d));
      }
    }
    return listBookHistory;
  }

  final _formKey = GlobalKey<FormState>();

  int index_rating = 0;
  int index_item = 0;
  int _currentIndex = 0;

  TextEditingController _username = TextEditingController();
  TextEditingController _bookname = TextEditingController();
  TextEditingController _rating = TextEditingController();
  TextEditingController _review= TextEditingController();

  // String _username = "";
  // String _bookname = "";
  // String _rating = "";
  // String _review = "";

  // String dropDownValue = "";
  // String rating = "";
  List<DropdownMenuItem<String>> dropDownItems = [];
  List<DropdownMenuItem<String>> dropDownRating = [
      DropdownMenuItem(value: "~~Rate The Book~~", child: Text("~~Rate The Book~~")),
      DropdownMenuItem(value: "1", child: Text("1")),
      DropdownMenuItem(value: "2", child: Text("2")),
      DropdownMenuItem(value: "3", child: Text("3")),
      DropdownMenuItem(value: "4", child: Text("4")),
      DropdownMenuItem(value: "5", child: Text("5")),
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    _username.text = user_username;

    var tabs = [
      FutureBuilder(
          future: fetchAllReview(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "Tidak ada review.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ProductDetailsPage(item: snapshot.data![index]),
                      //     ),
                      //   );
                      // },
                      child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data![index].fields.bookName}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("${snapshot.data![index].fields.username}"),
                        const SizedBox(height: 10),
                        Text(
                            "Rating: ${snapshot.data![index].fields.rating}/5"),
                        const SizedBox(height: 10),
                        Text("Comment: ${snapshot.data![index].fields.review}")
                      ],
                    ),
                  )),
                );
              }
            }
          }),

      Container(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Search Book"),
            centerTitle: true,
            actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final selected = await showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(items),
                    );
                    if (selected != null && selected != false) {
                      // Handle the selected item
                      print('Selected: $selected');
                    }
                  },
                ),
                
              ],
              
          ),
          body: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredItems[index]),
              );
            },
          ),
          // body: BooklistPage("", "", "", ""),
          ),
      ),
      
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add a Review'),
          // titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    child: 
                    DropdownButtonHideUnderline(
                      child: FutureBuilder(
                        future: bookHistory(request),
                        builder: (context, AsyncSnapshot<List<Buku>> snapshot) {
                          if (snapshot.hasError) {
                            return DropdownButton<String>(
                              items: dropDownItems,
                              onChanged: (String? selected) {
                                // Handle the selected item here
                              },
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
                            return DropdownButton<String>(
                              value: dropDownItems[index_item].value,
                              onChanged: (String? selected) {
                                setState(() {
                                  _bookname.text = selected!;
                                });
                              },
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
                      child: DropdownButton<String>(
                        value: dropDownRating[index_rating].value,
                        onChanged: (String? value) {
                          setState(() {
                            if(value == "~~Rate The Book~~") {
                              index_rating = 0;
                            } else {
                              index_rating = int.tryParse(value!)!;
                            }

                            if(value != "~~Rate The Book~~"){
                              _rating.text = value!;
                            } else {
                              _rating.text = "";
                            }
                          });
                        },
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
                      // validator: (String? value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Fill out the blank review!";
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  const SizedBox(height: 24.0),
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
                              'username': _username.text,
                              'bookname': _bookname.text,
                              'rating': _rating.text,
                              'review': _review.text,
                            }));

                        if (response['status']) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Your review is successfully submitted!"),
                          ));
                          if (!context.mounted) return;
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
                  const SizedBox(height: 24.0),
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

      FutureBuilder(
          future: fetchMyReview(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "Tidak ada review.",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ProductDetailsPage(item: snapshot.data![index]),
                      //     ),
                      //   );
                      // },
                      child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data![index].fields.bookName}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("${snapshot.data![index].fields.username}"),
                        const SizedBox(height: 10),
                        Text(
                            "Rating: ${snapshot.data![index].fields.rating}/5"),
                        const SizedBox(height: 10),
                        Text("Comment: ${snapshot.data![index].fields.review}")
                      ],
                    ),
                  )),
                );
              }
            }
          }),
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF377C35),
          foregroundColor: Colors.white,
          title: const Center(
            child: Text("Forum Reviews", style: TextStyle(color: Colors.white)),
          )),
      drawer: const LeftDrawer(),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: (index) {
            setState(() {
              _currentIndex = index; 
              if(user_id == 0 && _currentIndex == 2){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
                _currentIndex = 0;
              } 
            });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: "Their Review",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add a Review",
          ),
          if(user_id != 0)...{
            BottomNavigationBarItem(
              icon: Icon(Icons.reviews_rounded),
              label: "My Review",
            ),
          },
        ],
      ),
    );
  }
}

List<String> items = List.generate(100, (index) => 'Item $index');
List<String> filteredItems = [];
class CustomSearchDelegate extends SearchDelegate {
  final List<String> items;

  CustomSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, false);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filteredItems = items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredItems[index]),
          onTap: () {
            close(context, filteredItems[index]);
          },
        );
      },
    );
  }
}
