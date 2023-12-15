import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/forumreview_models/review.dart';
import 'package:read_and_brew/screens/login.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReviews> {
  Future<List<Review>> fetchMyReview(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
    var data =
        await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review-member/');
    // melakukan konversi data json menjadi object Review
    List<Review> listMyReview = [];
    for (var d in data) {
      if (d != null && d['fields']['user'] == user_id) {
        listMyReview.add(Review.fromJson(d));
      }
    }

    return listMyReview;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
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
          });
  }    
}