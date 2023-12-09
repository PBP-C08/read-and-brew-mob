import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/foodmenu.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/menu_card.dart';
import 'package:read_and_brew/screens/login.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final List<Menu> items = [
    Menu("Book List", Icons.checklist, Color(0xFF377C35)),
    Menu("Book Tracker", Icons.track_changes, Color(0xFF377C35)),
    Menu("Forum Review", Icons.reviews, Color(0xFF377C35)),
    Menu("Book Request", Icons.request_page, Color(0xFF377C35)),
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF377C35)),
        actions: [
          IconButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
              backgroundColor: user_id == 0
                  ? MaterialStateProperty.all<Color>(Color(0xFF377C35))
                  : MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 192, 29, 18)),
            ),
            icon: user_id == 0
                ? Icon(Icons.login, color: Colors.white)
                : Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              if (user_id == 0) {
                // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup ShopFormPage.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              } else {
                final response = await request.logout(
                    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                    "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/auth/logout/");
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
              }
            },
          ),
        ],
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
                child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 200,
                    width: 200),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 2.5),
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
              const Padding(
                padding: EdgeInsets.only(top: 2.5, bottom: 20.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Library Cafe', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF377C35)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (user_id == 0) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FoodMenu()),
                        );
                      } else {
                        if (user_status == "M") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => FoodMenu()),
                          );
                        } else if (user_status == "E") {}
                      }
                    },
                    child: Text(
                      user_status == "E" && user_id != 0
                          ? 'Inventory'
                          : 'Order Here',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Features:', // Text yang menandakan toko
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
                crossAxisCount: 2,
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
