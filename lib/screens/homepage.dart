import 'package:flutter/material.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/menu_card.dart';
import 'package:read_and_brew/screens/login.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final List<Menu> items = [
    Menu("Book List", Icons.checklist, Colors.brown),
    Menu("Book Tracker", Icons.track_changes, Colors.brown),
    Menu("Forum Review", Icons.reviews, Colors.brown),
    Menu("Order & Borrow", Icons.add, Colors.brown),
    Menu("Book Request", Icons.request_page, Colors.brown),
    if (user_id == 0) ...[
      Menu("Login", Icons.login, Colors.green),
    ] else ...[
      Menu("Log Out", Icons.logout, Colors.red),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Read and Brew',
          ),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Read and Brew', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((Menu item) {
                  // Iterasi untuk setiap item
                  return MenuWidget(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
