import 'package:flutter/material.dart';
// TODO: Impor halaman BookFormPage jika sudah dibuat
import 'package:read_and_brew/screens/booklist.dart';
import 'package:read_and_brew/screens/forum_review.dart';
import 'package:read_and_brew/screens/homepage.dart';
import 'package:read_and_brew/screens/tracker.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/guest/foodmenu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
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
                    color: Colors.black,
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.5)),
                Text("Library Cafe",
                    // TODO: Tambahkan gaya teks dengan center alignment, font ukuran 15, warna putih, dan weight biasa
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          // TODO: Bagian routing
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
            ),
            title: const Text('Home Page'),
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
            leading: const Icon(
              Icons.checklist,
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
                MaterialPageRoute(
                    builder: (context) => BooklistPage("", "", "", "")),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.track_changes,
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
            leading: const Icon(
              Icons.reviews,
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
            leading: const Icon(
              Icons.restaurant_menu,
            ),
            title: const Text('Order & Borrow'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodMenu(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.request_page,
            ),
            title: const Text('Book Request'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
            },
          ),
        ],
      ),
    );
  }
}
