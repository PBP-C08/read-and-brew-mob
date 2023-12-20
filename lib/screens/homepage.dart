import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/orderpage.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/employee/inventory.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/menu_card.dart';
import 'package:read_and_brew/screens/login.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final List<Menu> items = [
    Menu("Book List", Icons.book_rounded, Color(0xFF377C35)),
    Menu("Book Tracker", Icons.add_task, Color(0xFF377C35)),
    Menu("Forum Review", Icons.rate_review, Color(0xFF377C35)),
    Menu("Book Request", Icons.note_add, Color(0xFF377C35)),
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
            Color.fromARGB(255, 172, 255, 169),
            Color.fromARGB(255, 172, 255, 169)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
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
            child: Column(
              // Widget untuk menampilkan children secara vertikal
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft, // Add this
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                    child: Text(
                      'Welcome,', // Text yang menandakan toko
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF377C35),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                    child: user_id != 0
                        ? Text(
                            user_username, // Text yang menandakan toko
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF377C35),
                            ),
                          )
                        : Text(
                            "Guest", // Text yang menandakan toko
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF377C35),
                            ),
                          ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20, bottom: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(24),
                      elevation: 4,
                      child: Container(
                          height: 155,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(24), // Set border radius
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(55, 122, 59, 1),
                                Color.fromRGBO(16, 68, 19, 1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 15, left: 15, top: 25, bottom: 20),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    // Set the width as per your requirement
                                    height:
                                        85, // Set the height as per your requirement
                                    child: Image.asset(
                                        'assets/images/homepageart.png'),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    (user_status == "M" && user_id != 0) ||
                                            user_id == 0
                                        ? 'Taste Our Finest\nFoods and\nBeverages'
                                        : 'Check out\nour inventory',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: Color(0x26D2D2D2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(11.29),
                                        ),
                                      ),
                                      width:
                                          85, // Set the width as per your requirement
                                      height:
                                          25, // Set the height as per your requirement
                                      child: InkWell(
                                        onTap: () {
                                          if (user_id == 0) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderPage()),
                                            );
                                          } else {
                                            if (user_status == "M") {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderPage()),
                                              );
                                            } else if (user_status == "E") {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        InventoryPage(),
                                                  ));
                                            }
                                          }
                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                user_status == "E" &&
                                                        user_id != 0
                                                    ? 'Inventory'
                                                    : 'Order Here',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_forward, // This is the arrow right icon
                                                color: Colors
                                                    .white, // Set the color as per your requirement
                                                size:
                                                    10, // Set the size as per your requirement
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          )),
                    )),
                // Grid layout
              ],
            ),
          ),
          bottomNavigationBar: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Material(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.black,
                child: GridView.count(
                  primary: true,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 30, bottom: 30),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: items.map((Menu item) {
                    return MenuWidget(item);
                  }).toList(),
                ),
              ))),
    );
  }
}
