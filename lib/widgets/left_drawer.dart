import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/booklist.dart';
import 'package:read_and_brew/screens/bookrequest.dart';
import 'package:read_and_brew/screens/forumreview_screens/forum_review.dart';
import 'package:read_and_brew/screens/homepage.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/orderpage.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/employee/inventory.dart';
import 'package:read_and_brew/screens/tracker.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        children: [
          DrawerHeader(
            // TODO: Bagian drawer headerb
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 55,
                    height: 55,
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.5)),
                Text(
                  'Read and Brew',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30 *
                        MediaQuery.of(context).size.width /
                        400, // Adjust the font size based on the screen width
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 36, 81, 35),
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.5)),
                Text(
                  "Library Cafe",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15 *
                        MediaQuery.of(context).size.width /
                        400, // Adjust the font size based on the screen width
                    color: Color.fromARGB(255, 36, 81, 35),
                  ),
                ),
              ],
            ),
          ),
          // TODO: Bagian routing
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: const Icon(
              Icons.home_outlined,
            ),
            title: Text('Home Page'),
            // Bagian redirection ke MyHomePage
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
            leading: const Icon(
              Icons.book_rounded,
            ),
            title: const Text('Book List'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
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
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
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
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
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
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
              if (user_status == 'E' || user_status == 'M')
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestBukuPage()));
              else
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Anda harus login untuk mengakses halaman ini!"),
                ));
            },
          ),
          ListTile(
            textColor: Color.fromARGB(255, 36, 81, 35),
            iconColor: Color.fromARGB(255, 36, 81, 35),
            leading: Icon(user_status == "E" && user_id != 0
                ? Icons.home_repair_service
                : Icons.restaurant_menu),
            title: Text(user_status == "E" && user_id != 0
                ? 'Inventory'
                : 'Order & Borrow'),
            onTap: () {
              if (user_id == 0) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ));
              } else {
                if (user_status == "M") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderPage(),
                      ));
                } else if (user_status == "E") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventoryPage(),
                      ));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
