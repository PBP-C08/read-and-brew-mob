import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/models/forumreview_models/review.dart';
import 'package:read_and_brew/screens/forumreview_screens/review_details.dart';

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
      future: fetchAllReview(request),
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
                  Buku? currentBuku = bookSnapshot.data;

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

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewDetailsPage(buku: currentBuku, review: currentReview),
                              ),
                            );
                          },
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
                                const SizedBox(width: 8,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentReview.fields.bookName,
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
                                      Text(currentReview.fields.username),
                                      const SizedBox(height: 10),
                                      Text("Comment: ${currentReview.fields.review}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
