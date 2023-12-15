import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/forumreview_models/review.dart';

class TheirReviews extends StatefulWidget {
  @override
  _TheirReviewState createState() => _TheirReviewState();
}

class _TheirReviewState extends State<TheirReviews> {
  Future<List<Review>> fetchAllReview(request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // melakukan decode response menjadi bentuk json
    var data =
        await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review/');
    // melakukan konversi data json menjadi object Review
    List<Review> listAllReview = [];
    for (var d in data) {
      if (d != null) {
        listAllReview.add(Review.fromJson(d));
      }
    }
    return listAllReview;
  }
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
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
        });
  }}
