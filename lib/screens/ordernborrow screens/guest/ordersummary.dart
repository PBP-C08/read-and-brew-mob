import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/ordernborrow%20models/Order.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/guest/drinkmenu.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/guest/foodmenu.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';
import 'package:responsive_card/responsive_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _currentIndex = 2;
  final List<Widget> _pages = [
    FoodMenu(),
    DrinkMenu(),
    OrderPage(),
  ];
  Future<List<Order>> fetchOrder() async {
    var url =
        Uri.parse('http://localhost:8000/ordernborrow/guest/get-product/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Order> listOrder = [];

    for (var d in data) {
      if (d != null) {
        listOrder.add(Order.fromJson(d));
      }
    }
    return listOrder;
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String totalCost) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Payment"),
          content: Text(
              "Are you sure you want to pay \$$totalCost for all your orders?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dialog cancelled
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllOrders(CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/ordernborrow/guest/delete-all-order-flutter/",
      jsonEncode({}),
    );

    if (response['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderPage()),
      );
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Payment Successful"),
            content: const Text(
                "Thank you for coming here! Please come back again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the pop-up
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment failed. Please try again."),
        ),
      );
    }
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat("MMMM d, y 'at' hh:mm:ss a", 'en_US');
    return formatter.format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: const Color(0xFF377C35),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchOrder(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List<Order> orders = snapshot.data ?? [];

            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  "You haven't ordered anything.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              double totalCost = orders.fold(0.0, (sum, order) {
                double price = double.parse(order.fields.foodPrice);
                return sum + (price * order.fields.amount);
              });
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        Order item = orders[index];
                        double price = double.parse(item.fields.foodPrice);
                        double totalPrice = price * item.fields.amount;
                        return Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Adjust the padding as needed
                          child: ResponsiveCard(
                            bgColor: Colors.white,
                            screenWidth: 600,
                            title: Text(
                              item.fields.foodName,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            subTitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount: ${item.fields.amount}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  "Date Ordered: ${formatDate(item.fields.orderDate)}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: EDIT ORDER
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Edit initiated."),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Edit"),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: DELETE ORDER
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Delete initiated."),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Cost: \$${totalCost.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool confirmed = await _showConfirmationDialog(
                                context, totalCost.toStringAsFixed(2));
                            if (confirmed) {
                              await _deleteAllOrders(request);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Pay Now"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Drinks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Order Summary',
          ),
        ],
        selectedItemColor: const Color(0xFF377C35),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to the selected page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _pages[_currentIndex]),
          );
        },
      ),
    );
  }
}
