import 'package:flutter/material.dart';
// TODO: Impor halaman BookFormPage jika sudah dibuat
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/homepage.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            // TODO: Bagian drawer header
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Column(
              children: [
                Text(
                  'Read and Brew',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text("Cafe Library",
                    // TODO: Tambahkan gaya teks dengan center alignment, font ukuran 15, warna putih, dan weight biasa
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          // TODO: Bagian routing
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Book List'),
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
            leading: const Icon(Icons.track_changes),
            title: const Text('Book Tracker'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
            },
          ),
          ListTile(
            leading: const Icon(Icons.reviews),
            title: const Text('Forum Review'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Order & Borrow'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Book Request'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            tileColor: Colors.red,
            textColor: Colors.white,
            iconColor: Colors.white,
            // Bagian redirection ke BookFormPage
            onTap: () async {
              /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
            },
          )
        ],
      ),
    );
  }
}
