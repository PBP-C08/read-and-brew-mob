import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/booklist.dart';
import 'package:read_and_brew/screens/bookrequest.dart';
import 'package:read_and_brew/screens/forumreview_screens/forum_review.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/screens/tracker.dart';

class Menu {
  final String name;
  final IconData icon;
  final Color color;

  Menu(this.name, this.icon, this.color);
}

class MenuWidget extends StatelessWidget {
  final Menu item;

  const MenuWidget(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF377C35), // Set border color
            width: 2, // Set border width
          ),
          borderRadius: BorderRadius.circular(24), // Set border radius
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            // Area responsive terhadap sentuhan
            onTap: () async {
              if (item.name == "Book List") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BooklistPage()),
                );
              } else if (item.name == "Forum Review") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewPage()),
                );
              } else if (item.name == "Book Request") {
                // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup ShopFormPage.
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
              } else if (item.name == "Book Tracker") {
                // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup ShopFormPage.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookTrackerPage()));
              }
            },
            child: Container(
              // Container untuk menyimpan Icon dan Text
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Icon(
                      item.icon,
                      color: Color(0xFF377C35),
                      size: 40.0,
                    )),
                    const Padding(padding: EdgeInsets.all(3)),
                    Flexible(
                      // Add this
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF377C35),
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
