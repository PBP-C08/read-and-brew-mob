import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/models/forumreview_models/review.dart';

class ListGambar extends StatefulWidget {
  const ListGambar({super.key});

  @override
  _ListGambarState createState() => _ListGambarState();
}

class _ListGambarState extends State<ListGambar> {
  Future<List<Review>> fetchAllReview(request) async {
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return OrientationBuilder(builder: (context, orientation) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24), 
                child: Center(
                  child: Text(
                    "Search a Review by Book Name or Username",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center
                  ),
                )
              ),
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
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
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
                                    width: 120,
                                    height: 180,
                                  );
                                }
                              }
                            }

                            return Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        child: bookImageWidget,
                                      ),
                                    ),
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
              ),
            ],
          ),
        );
      },
    );
  }
}