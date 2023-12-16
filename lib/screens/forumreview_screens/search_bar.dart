import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/models/forumreview_models/review.dart';
import 'package:read_and_brew/screens/forumreview_screens/list_gambar.dart';
import 'package:read_and_brew/screens/forumreview_screens/review_details.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
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

class SearchPageState extends State<SearchPage> {
  Future<Buku?> getBookByName(request, bookName) async {
    var data =
        await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');

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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return SearchBarPage(
      request: request,
      builder: (selectedBookName, selectedUsername, filteredItems) {
        return ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (_, index) {
            Review currentReview = filteredItems[index];

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
                            builder: (context) =>
                                ReviewDetailsPage(buku: currentBuku, review: currentReview),
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
                            const SizedBox(
                              width: 8,
                            ),
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
      },
    );
  }
}

class SearchBarPage extends StatefulWidget {
  final CookieRequest request;
  final Function(String, String, List<Review>) builder;

  SearchBarPage({required this.request, required this.builder});

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  List<Review> filteredItems = [];
  String selectedBookName = '';
  String selectedUsername = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Review"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final selected = await showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  request: widget.request,
                  onItemSelected: (selectedItems, bookName, username) {
                    setState(() {
                      filteredItems = selectedItems;
                      selectedBookName = bookName;
                      selectedUsername = username;
                    });
                  },
                ),
              );
              if (selected != null && selected != false) {
                // Handle the selected item
                print('Selected: $selected');
              }
            },
          ),
        ],
      ),
      body: filteredItems.isEmpty ? const ListGambar() : widget.builder(selectedBookName, selectedUsername, filteredItems),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final CookieRequest request;
  final Function(List<Review>, String, String) onItemSelected;

  CustomSearchDelegate({required this.request, required this.onItemSelected});

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
    return FutureBuilder(
      future: fetchReviewsByName(request, query),
      builder: (context, AsyncSnapshot<List<Review>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching reviews"));
        } else {
          List<Review> reviews = snapshot.data ?? [];

          if (reviews.isEmpty) {
            return Center(child: Text("No reviews found for the selected book"));
          } else {
            onItemSelected([reviews.first], query, ''); // Pass only the selected review
            return Container();
          }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text("Start typing to search for books or usernames"));
    } else {
      return FutureBuilder(
        future: fetchReviewsByName(request, query),
        builder: (context, AsyncSnapshot<List<Review>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          } else {
            List<Review> reviews = snapshot.data ?? [];

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${reviews[index].fields.bookName}\nBy: ${reviews[index].fields.username}"),
                  subtitle: 
                    buildRatingStars(reviews[index].fields.rating),

                  isThreeLine: true,
                  onTap: () {
                    onItemSelected([reviews[index]], query, ''); // Pass only the selected review
                    close(context, reviews[index]);
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  Future<List<Review>?> fetchReviewsByName(CookieRequest request, String name) async {
    try {
      var data =
          await request.get('https://readandbrew-c08-tk.pbp.cs.ui.ac.id/reviewmodul/get-review/');

      List<Review> listAllReview = [];
      List<Review> sortedReview = [];

      for (var d in data) {
        if (d != null) {
          listAllReview.add(Review.fromJson(d));
        }
      }

      for (var d in listAllReview) {
        if (d.fields.bookName.toLowerCase().contains(name.toLowerCase()) ||
            d.fields.username.toLowerCase().contains(name.toLowerCase())) {
          sortedReview.add(d);
        }
      }

      return sortedReview;
    } catch (error) {
      print('Error fetching reviews: $error');
      return null;
    }
  }
}
