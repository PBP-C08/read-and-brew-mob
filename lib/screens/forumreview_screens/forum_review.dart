import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/forumreview_screens/add_review.dart';
import 'package:read_and_brew/screens/forumreview_screens/my_review.dart';
import 'package:read_and_brew/screens/forumreview_screens/search_bar.dart';
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

bool deleteMode = false;

class ReviewPageState extends State<ReviewPage> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    var tabs = [
        TheirReviews(),
        SearchPage(),
        AddReview(),
        MyReviews(),
    ];

    if (user_id == 0){
      tabs = [
        TheirReviews(),
        SearchPage(),
        // ignore: prefer_const_constructors
        LoginPage(),
      ];
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF377C35),
          foregroundColor: Colors.white,
          actions: [
            if(_currentIndex==3)...{
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: deleteMode == false ? Colors.white : Colors.red,
                  onPressed: () {
                    setState(() {
                      if(deleteMode == false) {
                        deleteMode = true;
                      } else {
                        deleteMode = false;
                      }
                    });
                  },
                ),
            }
          ],
          title: const Center(
            child: Text("Forum Reviews", style: TextStyle(color: Colors.white)),
          )),
      
      drawer: const LeftDrawer(),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF377C35),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if(_currentIndex == 3){
              deleteMode = false;
            }
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: "Their Review",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add a Review",
          ),
          if (user_id != 0) ...{
            const BottomNavigationBarItem(
              icon: Icon(Icons.reviews_rounded),
              label: "My Review",
            ),
          },
        ],
      ),
    );
  }
}

