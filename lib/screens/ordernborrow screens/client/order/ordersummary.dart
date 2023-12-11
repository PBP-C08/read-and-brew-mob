import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/models/ordernborrow%20models/Order.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:responsive_card/responsive_card.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({Key? key}) : super(key: key);

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late Future<List<Order>> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = fetchOrder();
  }

  Future<List<Order>> fetchOrder() async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/guest/get-product/');
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

  Future<void> refreshOrderData() async {
    final newOrderData = await fetchOrder();
    setState(() {
      futureOrder = Future.value(newOrderData);
    });
  }

  Future<bool> _showPaymentConfirmationDialog(
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
      "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/guest/delete-all-order-flutter/",
      jsonEncode({}),
    );

    if (response['status'] == 'success') {
      refreshOrderData();
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
                  Navigator.pop(context);
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
      Navigator.pop(context);
    }
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat("MMMM d, y 'at' hh:mm:ss a", 'en_US');
    return formatter.format(date.toLocal());
  }

  Future<void> _showConfirmEditDialog(
      BuildContext context, Order item, CookieRequest request) async {
    TextEditingController _amountController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    int _amount = item.fields.amount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.fields.foodName),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Amount: ${item.fields.amount}"),
                SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'New Amount',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _amount = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Amount must be a valid number!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Amount must be a valid number!";
                    }
                    int enteredAmount = int.tryParse(value) ?? 0;
                    if (enteredAmount < 1) {
                      return "Amount must be at least 1!";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _formKey.currentState!.reset();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final response = await request.postJson(
                      "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/guest/edit-order-flutter/${item.pk}/",
                      jsonEncode({
                        'amount': _amount.toString(),
                      }));

                  if (response['status'] == 'success') {
                    Navigator.pop(context);
                    refreshOrderData();
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Success!"),
                          content: const Text("Order successfully edited!"),
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Sorry there seems to be a problem, please try again."),
                    ));
                  }
                  _formKey.currentState!.reset();
                  Navigator.pop(context);
                }
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, Order item) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text(
              "Are you sure you want to delete \"${item.fields.foodName}\" from your order?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(CookieRequest request, Order order) async {
    final response = await request.postJson(
      "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/guest/delete-order-flutter/${order.pk}/",
      jsonEncode({}),
    );

    if (response['status'] == 'success') {
      refreshOrderData();
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Successful"),
            content: const Text("Your order has been deleted successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // List<BottomNavigationBarItem> bottomNavBarItems = [
    //   const BottomNavigationBarItem(
    //     icon: Icon(Icons.restaurant),
    //     label: 'Food',
    //   ),
    //   const BottomNavigationBarItem(
    //     icon: Icon(Icons.local_cafe),
    //     label: 'Drinks',
    //   ),
    //   const BottomNavigationBarItem(
    //     icon: Icon(Icons.receipt_long),
    //     label: 'Order Summary',
    //   ),
    // ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: const Color(0xFF377C35),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: futureOrder,
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
                          padding: const EdgeInsets.all(10.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Spacer(), // This will push the IconButton to the right
                                    ElevatedButton(
                                      onPressed: () {
                                        _showConfirmEditDialog(
                                            context, item, request);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Edit"),
                                    ),
                                    Spacer(), // This will push the IconButton to the right
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        bool confirmed =
                                            await _showDeleteConfirmationDialog(
                                                context, item);
                                        if (confirmed) {
                                          await _deleteOrder(request, item);
                                        } else {}
                                      },
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
                            bool confirmed =
                                await _showPaymentConfirmationDialog(
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
      // bottomNavigationBar: BottomNavigationBar(
      //   items: bottomNavBarItems,
      //   unselectedItemColor: Colors.grey,
      //   selectedItemColor: const Color(0xFF377C35),
      //   currentIndex: _currentIndex,
      //   onTap: (int index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => _pages[_currentIndex]),
      //     );
      //   },
      // ),
    );
  }
}
