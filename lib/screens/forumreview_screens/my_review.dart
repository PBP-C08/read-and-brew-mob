import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/forumreview_models/review.dart';
import 'package:read_and_brew/screens/forumreview_screens/forum_review.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReviews> {
  late Future<List<Review>> futureReview;

  @override
  void initState() {
    super.initState();
    futureReview = fetchMyReview(context.read<CookieRequest>());
  }

  Future<List<Review>> fetchMyReview(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
    var data =
        await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review-member/');
    List<Review> listReview = [];

    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    return listReview;
  }

  Future<void> refreshReviewData(request) async {
    final newReviewData = await fetchMyReview(request);
    setState(() {
      futureReview = Future.value(newReviewData);
    });
  }

  Future<void> _deleteReview(CookieRequest request, Review review) async {
    final response = await request.postJson(
      "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/delete-review-flutter/${review.pk}/",
      jsonEncode({}),
    );

    if (response['status'] == 'success') {
      refreshReviewData(request);
      if(!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Successful"),
            content: const Text("Your review has been deleted successfully!"),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Delete failed. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
          future: futureReview,
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
                        Text("Comment: ${snapshot.data![index].fields.review}"),
                        const SizedBox(height: 10),
                        if(deleteMode == true)...{
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                _deleteReview(request, snapshot.data![index]);
                              },
                            ),
                          ),
                        }
                      ],
                    ),
                  )),
                );
              }
            }
          });
  }    
}