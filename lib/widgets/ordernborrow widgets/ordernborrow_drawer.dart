import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/booklist.dart';
import 'package:read_and_brew/screens/bookrequest.dart';
import 'package:read_and_brew/screens/forumreview_screens/forum_review.dart';
import 'package:read_and_brew/screens/homepage.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/books.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrowpage.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/orderpage.dart';
import 'package:read_and_brew/screens/tracker.dart';

class OnBDrawer extends StatelessWidget {
  const OnBDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 55,
                  height: 55,
                ),
                Padding(padding: EdgeInsets.all(2.5)),
                Text(
                  'Read and Brew',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 36, 81, 35),
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.5)),
                Text("Library Cafe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 36, 81, 35),
                    )),
              ],
            ),
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(
              Icons.home_outlined,
            ),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Order'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ));
            },
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(
              Icons.menu_book,
            ),
            title: const Text('Borrow'),
            onTap: () {
              indexBorrow = 0;
              judul_found = '';
              kategori_found = '';
              sort_found = '';
              order_found = '';
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BorrowPage(),
                  ));
            },
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(
              Icons.book_rounded,
            ),
            title: const Text('Book List'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BooklistPage()),
              );
            },
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(
              Icons.add_task,
            ),
            title: const Text('Book Tracker'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BookTrackerPage()),
              );
            },
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(
              Icons.rate_review,
            ),
            title: const Text('Forum Review'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReviewPage()),
              );
            },
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(
              Icons.note_add,
            ),
            title: const Text('Book Request'),
            onTap: () {
              if (user_status == 'E' || user_status == 'M')
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestBukuPage()));
              else
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Anda harus login untuk mengakses halaman ini!"),
                ));
            },
          ),
        ],
      ),
    );
  }
}