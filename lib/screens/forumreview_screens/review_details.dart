import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/models/forumreview_models/review.dart';

class ReviewDetailsPage extends StatelessWidget {
  final Buku? buku;
  final Review review;

  const ReviewDetailsPage({Key? key, required this.buku, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Details"),
        backgroundColor: Color(0xFF377C35),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.network(
                  buku!.fields.gambar,
                  width: 160,
                  height: 240,
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Name: ${review.fields.bookName}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: RatingBar.builder(
                    initialRating: review.fields.rating.toDouble(),
                    minRating: 0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    ignoreGestures: true,
                    onRatingUpdate: (double value) {},
                  ),
                ),
                const SizedBox(height: 12),
                Text("By: ${review.fields.username}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 12),
                Text(
                  "Comment: ${review.fields.review}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
