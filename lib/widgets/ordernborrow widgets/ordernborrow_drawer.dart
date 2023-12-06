import 'package:flutter/material.dart';
// TODO: Impor halaman BookFormPage jika sudah dibuat
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/homepage.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/drinkmenu.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/foodmenu.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/ordersummary.dart';

class OnBDrawer extends StatelessWidget {
  const OnBDrawer({super.key});

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
            leading: const Icon(Icons.restaurant),
            title: const Text('Food'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodMenu(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_cafe),
            title: const Text('Drinks'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DrinkMenu(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Order Summary'),
            // Bagian redirection ke BookFormPage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.request_page),
          //   title: const Text('Book Request'),
          //   // Bagian redirection ke BookFormPage
          //   onTap: () {
          //     /*
          //     TODO: Buatlah routing ke BookFormPage di sini,
          //     setelah halaman BookFormPage sudah dibuat.
          //     */
          //   },
          // ),
          if (user_id == 0) ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              tileColor: Colors.green,
              textColor: Colors.white,
              iconColor: Colors.white,
              // Bagian redirection ke BookFormPage
              onTap: () async {
                /*
              TODO: Buatlah routing ke BookFormPage di sini,
              setelah halaman BookFormPage sudah dibuat.
              */
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
            ),
          ] else ...[
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
              },
            ),
          ],
        ],
      ),
    );
  }
}
