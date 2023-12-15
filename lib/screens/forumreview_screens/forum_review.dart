import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/forumreview_screens/add_review.dart';
import 'package:read_and_brew/screens/forumreview_screens/my_review.dart';
import 'package:read_and_brew/screens/forumreview_screens/their_reviews.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
// import 'package:read_and_brew/models/ordernborrow models/BorrowedHistory.dart';
// import 'package:read_and_brew/screens/booklist.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var tabs = [
        TheirReviews(),
        const SearchBar(),
        AddReview(),
        MyReviews(),
    ];

    if (user_id == 0){
      tabs = [
        TheirReviews(),
        const SearchBar(),
        const LoginPage(),
      ];
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF377C35),
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
            // if (user_id == 0 && _currentIndex == 2) {
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => const LoginPage()));
            //   _currentIndex = 0;
            // }
          });
        },
        items: [
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
          if (user_id != 0) ...{
            BottomNavigationBarItem(
              icon: Icon(Icons.reviews_rounded),
              label: "My Review",
            ),
          },
        ],
      ),
    );
  }
}

