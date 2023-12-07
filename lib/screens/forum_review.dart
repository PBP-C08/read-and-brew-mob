import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/review.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/models/ordernborrow models/BorrowedHistory.dart';
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
  Future<List<BorrowedHistory>> bookHistory(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
    var data = await request.get(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get_borrowed_history_json_member/');
    // melakukan konversi data json menjadi object Review
    List<BorrowedHistory> listBookHistory = [];
    for (var d in data) {
      if (d != null) {
        listBookHistory.add(BorrowedHistory.fromJson(d));
      }
    }
    return listBookHistory;
  }

  int _currentIndex = 0;
  String dropDownValue = "";
  String dropDownRating = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _username = TextEditingController();
    final TextEditingController _bookname = TextEditingController();
    TextEditingController _rating = TextEditingController();
    final TextEditingController _review = TextEditingController();

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

      const Center(child: Text("Search (Still on progress)")),
      
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    DropdownMenu<String>(
                        initialSelection: dropDownValue,
                        width: 317,
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropDownValue = value!;
                          });
                        },
                        dropdownMenuEntries:[DropdownMenuEntry(value: "Test", label: "Test")],
                      ),
                    // DropdownButtonHideUnderline(
                    //     child: FutureBuilder(
                    //       future: bookHistory(request),
                    //       builder: (context, AsyncSnapshot<List<BorrowedHistory>> snapshot) {
                    //         if (snapshot.hasError) {
                    //           return Container();
                    //         } else if (snapshot.hasData) {
                    //           List<DropdownMenuItem<int>> dropDownItems = [];
                    //           for (var item in snapshot.data!) {
                    //             dropDownItems.add(
                    //               DropdownMenuItem(
                    //                 value: item.pk, // Assuming BorrowedHistory has an 'id' property
                    //                 child: Text(item.fields.book.toString()), // Replace with the actual property you want to display
                    //               ),
                    //             );
                    //           }

                    //           return DropdownButton(
                    //             items: dropDownItems,
                    //             onChanged: (int? selected) {
                    //               // Handle the selected item here
                    //             },
                    //             hint: Text(
                    //               "Select Book",
                    //               style: TextStyle(color: Colors.blue),
                    //             ),
                    //           );
                    //         } else {
                    //           return CircularProgressIndicator();
                    //         }
                    //       },
                    //     ),
                    //   ),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: 
                    DropdownMenu<String>(
                        initialSelection: "Rate The Book",
                        width: 317,
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            _rating = value! as TextEditingController;
                          });
                        },
                        dropdownMenuEntries: const [DropdownMenuEntry(value: "1", label: "1"),
                                              DropdownMenuEntry(value: "2", label: "2"),
                                              DropdownMenuEntry(value: "3", label: "3"),
                                              DropdownMenuEntry(value: "4", label: "4"),
                                              DropdownMenuEntry(value: "5", label: "5")],
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _review,
                      decoration: InputDecoration(
                        hintText: "Review",
                        labelText: "Review",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Fill out the blank review!";
                        }
                        return null;
                      },
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
