import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/buku.dart';
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

  Future<Buku?> getBookByName(request, bookName) async {
    var data =
        await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');
    
    List<Buku> bookList = [];
    
    for(var d in data){
      if (d != null) {
        bookList.add(Buku.fromJson(d));
      }
    }

    for(var d in bookList){
      if(d.fields.judul.contains(bookName)){
        return d;
      }
    }

    return null;
  }

  Widget buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
      future: fetchMyReview(request),
      builder: (context, AsyncSnapshot<List<Review>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
            itemBuilder: (_, index) {
              Review currentReview = snapshot.data![index];
              
              return FutureBuilder(
                future: getBookByName(request, currentReview.fields.bookName),
                builder: (context, AsyncSnapshot<Buku?> bookSnapshot) {
                  Widget bookImageWidget = Container(); 

                  if (bookSnapshot.connectionState == ConnectionState.done) {
                    if (bookSnapshot.hasError) {
                      bookImageWidget = Text('Error loading book information.');
                    } else if (bookSnapshot.hasData && bookSnapshot.data != null) {
                      String? imageUrl = bookSnapshot.data!.fields.gambar;
                      if (imageUrl.isNotEmpty) {
                        bookImageWidget = Image.network(
                          imageUrl,
                          width: 80, 
                          height: 120, 
                        );
                      }
                    }
                  }

                  return InkWell(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Center(child: Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: bookImageWidget,
                              )),
                            ],
                          ),
                          const SizedBox(width: 8),
                          
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${currentReview.fields.bookName}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                buildRatingStars(currentReview.fields.rating),
                                const SizedBox(height: 10),
                                Text("${currentReview.fields.username}"),
                                const SizedBox(height: 10),
                                Text("Comment: ${currentReview.fields.review}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                           if (deleteMode == true) ...{
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 45), 
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () async {
                                  _deleteReview(request, snapshot.data![index]);
                                },
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  } 
}