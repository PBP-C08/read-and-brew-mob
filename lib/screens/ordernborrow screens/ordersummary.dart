import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:read_and_brew/models/ordernborrow%20models/Order.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';
import 'package:responsive_card/responsive_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
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

  String formatDate(DateTime date) {
    return DateFormat("MMMM d, y 'at' hh:mm:ss a").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Color(0xFF377C35),
        foregroundColor: Colors.white,
      ),
      drawer: OnBDrawer(),
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
              return ListView.builder(
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
                        "${item.fields.foodName}",
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Date Ordered: ${formatDate(item.fields.orderDate)}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
