import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:read_and_brew/models/ordernborrow models/Order.dart';
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
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url =
        Uri.parse('http://localhost:8000/ordernborrow/guest/get-product/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Order
    List<Order> list_Order = [];
    for (var d in data) {
      if (d != null) {
        list_Order.add(Order.fromJson(d));
      }
    }
    return list_Order;
  }

  void _showOrderDetails(BuildContext context, Order item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double price = double.parse(item.fields.foodPrice);
        double totalPrice = price * item.fields.amount;
        return AlertDialog(
          title: Text(item.fields.foodName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Amount: ${item.fields.amount}",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: OnBDrawer(),
      body: FutureBuilder(
        future: fetchOrder(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data.length == 0) {
              return const SizedBox(
                  height: 65,
                  child: Center(
                      child: Text("You haven't ordered anything.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))));
            } else {
              return ListView(
                children: List.generate(
                  snapshot.data.length,
                  (index) {
                    Order item = snapshot.data[index];
                    double price = double.parse(item.fields.foodPrice);
                    double totalPrice = price * item.fields.amount;
                    return ResponsiveCard(
                      elevation: 5,
                      titleGap: 20,
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
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
