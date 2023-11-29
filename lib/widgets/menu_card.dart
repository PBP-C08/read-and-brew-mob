import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/booklist.dart';
import 'package:read_and_brew/screens/bookrequest.dart';
import 'package:read_and_brew/screens/homepage.dart';
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
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if (item.name == "Login") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup ShopFormPage.
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }else if (item.name == "Log Out") {
            final response = await request.logout(
                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                "http://readandbrew-c08-tk.pbp.cs.ui.ac.id/auth/logout/");
            String message = response["message"];
            if (response['status']) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $user_username."),
              ));
              user_id = 0;
              user_username = "";
              user_status = "";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message"),
              ));
            }
          } else if (item.name == "Book List") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BooklistPage("", "", "", "")),
            );
          } else if (item.name == "Book Request") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup ShopFormPage.
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RequestBukuPage()));
          } else if (item.name == "Book Tracker") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup ShopFormPage.
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BookTrackerPage()));
          }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
