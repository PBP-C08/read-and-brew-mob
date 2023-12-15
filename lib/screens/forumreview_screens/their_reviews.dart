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

enum SortingOption {
  none,
  byNameAZ,
  byRatingAscending,
  byRatingDescending,
}

class _TheirReviewState extends State<TheirReviews> {
  SortingOption _selectedSortingOption = SortingOption.none;

  Future<List<Review>> fetchAllReview(request) async {
    // TODO: Replace the URL with your API endpoint
    var data = await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review/');
    List<Review> listAllReview = [];
    for (var d in data) {
      if (d != null) {
        listAllReview.add(Review.fromJson(d));
      }
    }
    return listAllReview;
  }

  Future<Buku?> getBookByName(request, bookName) async {
    // TODO: Replace the URL with your API endpoint
    var data = await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');

    List<Buku> bookList = [];
    for (var d in data) {
      if (d != null) {
        bookList.add(Buku.fromJson(d));
      }
    }

    for (var d in bookList) {
      if (d.fields.judul.contains(bookName)) {
        return d;
      }
    }

    return null;
  }

  List<Review> sortReviews(List<Review> reviews, SortingOption sortingOption) {
    switch (sortingOption) {
      case SortingOption.none:
        return reviews;
      case SortingOption.byNameAZ:
        return sortReviewsByName(reviews);
      case SortingOption.byRatingAscending:
        return sortReviewsByRatingAscending(reviews);
      case SortingOption.byRatingDescending:
        return sortReviewsByRatingDescending(reviews);
    }
  }

  List<Review> sortReviewsByName(List<Review> reviews) {
    reviews.sort((a, b) {
      int comparing = a.fields.bookName.compareTo(b.fields.bookName);
      if (comparing == 0) {
        return a.fields.rating.compareTo(b.fields.rating);
      } else {
        return comparing;
      }
    }
  );

  return reviews;
  }

  List<Review> sortReviewsByRatingAscending(List<Review> reviews) {
    reviews.sort((a, b){
      int comparing = a.fields.rating.compareTo(b.fields.rating);
      if (comparing == 0) {
        return a.fields.bookName.compareTo(b.fields.bookName);
      } else {
        return comparing;
      }
    });
    return reviews;
  }

  List<Review> sortReviewsByRatingDescending(List<Review> reviews) {
    reviews.sort((a, b) {
      int comparing = b.fields.rating.compareTo(a.fields.rating);
      if (comparing == 0) {
        return a.fields.bookName.compareTo(b.fields.bookName);
      } else {
        return comparing;
      }
    });
    return reviews;
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

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSortingDropdownButton(),
            FutureBuilder(
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
                  List<Review> sortedReviews = sortReviews(snapshot.data!, _selectedSortingOption);

                  return ListView.builder(
                    shrinkWrap: true,  
                    physics: const NeverScrollableScrollPhysics(),  
                    itemCount: sortedReviews.length,
                    itemBuilder: (_, index) {
                      Review currentReview = sortedReviews[index];

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
                                          Center(
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 16),
                                              child: bookImageWidget,
                                            ),
                                          ),
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
                                            Text(
                                              "Comment: ${currentReview.fields.review}",
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
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildSortingDropdownButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          contentPadding: EdgeInsets.all(10),
        ),
        child: Theme(                           
          data: Theme.of(context).copyWith(     
            splashColor: Colors.transparent,    
            highlightColor: Colors.transparent, 
            hoverColor: Colors.transparent,     
          ),
          child: DropdownButtonHideUnderline(
            child:DropdownButton<SortingOption>(
              icon: const Icon(Icons.sort),
              isExpanded: true,
              isDense: true,
              focusColor: Colors.transparent,
              value: _selectedSortingOption,
              onChanged: (SortingOption? newValue) {
                setState(() {
                  if (newValue != null) {
                    _selectedSortingOption = newValue;
                  }
                });
              },
              items: const [
                DropdownMenuItem(
                  value: SortingOption.none,
                  child: Text('Sort by'),
                ),
                DropdownMenuItem(
                  value: SortingOption.byNameAZ,
                  child: Text('Sort by Name (A-Z)'),
                ),
                DropdownMenuItem(
                  value: SortingOption.byRatingAscending,
                  child: Text('Sort by Rating (Ascending)'),
                ),
                DropdownMenuItem(
                  value: SortingOption.byRatingDescending,
                  child: Text('Sort by Rating (Descending)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
