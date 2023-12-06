import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/review.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
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
    List<Review> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    // for (var d in listReview) {
    //     Item newItem = Item(d.fields.name, d.fields.amount, d.fields.price, d.fields.power, d.fields.description);
    //     InventoryProduct.listReview.add(newItem);
    // }

    return listReview;
  }

  Future<List<Review>> fetchMyReview(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
    var data = await request.get(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review-member/');
    // melakukan konversi data json menjadi object Review
    List<Review> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }

    return listReview;
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _username = TextEditingController();
    final TextEditingController _bookname = TextEditingController();
    final TextEditingController _rating = TextEditingController();
    final TextEditingController _review = TextEditingController();

    // String _username = "";
    // String _bookname = "";
    // int _rating = 0;
    // String _review = "";

    final tabs = [
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
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add a Review'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Fill out the blank username!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _bookname,
                      decoration: InputDecoration(
                        hintText: "Book Name",
                        labelText: "Book Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Fill out the blank book name!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _rating,
                      decoration: InputDecoration(
                        hintText: "Rating",
                        labelText: "Rating",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Fill out the blank rating!";
                        }
                        if (int.tryParse(value) == null) {
                          return "Rating must be an numbers!";
                        }
                        return null;
                      },
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
          backgroundColor: Colors.brown,
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
          });
        },
        items: const [
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
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews_rounded),
            label: "My Review",
          ),
        ],
      ),
    );
  }
}
