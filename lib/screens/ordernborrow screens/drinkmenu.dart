import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';
import 'package:responsive_card/responsive_card.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class DrinkMenu extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      "pk": 1,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Latte",
        "price": 3.99,
        "description":
            "Espresso with creamy steamed milk and a hint of vanilla."
      }
    },
    {
      "pk": 2,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Cappuccino",
        "price": 4.49,
        "description":
            "Espresso topped with frothy milk and a sprinkle of cocoa."
      }
    },
    {
      "pk": 3,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Mocha",
        "price": 4.99,
        "description":
            "Rich espresso with velvety steamed milk, cocoa, and whipped cream."
      }
    },
    {
      "pk": 4,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Iced Coffee",
        "price": 3.49,
        "description":
            "Chilled coffee brewed to perfection, served with ice cubes."
      }
    },
    {
      "pk": 5,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Espresso",
        "price": 2.49,
        "description":
            "A shot of intense, concentrated coffee to awaken your senses."
      }
    },
    {
      "pk": 6,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Chai Latte",
        "price": 4.99,
        "description":
            "Spiced black tea combined with frothy milk for a delightful balance."
      }
    },
    {
      "pk": 7,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Caramel Macchiato",
        "price": 4.99,
        "description":
            "Espresso with steamed milk, caramel, and a caramel drizzle."
      }
    },
    {
      "pk": 8,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Iced Tea",
        "price": 3.29,
        "description":
            "Chilled tea infused with fruit essence, served over ice."
      }
    },
    {
      "pk": 9,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Hot Chocolate",
        "price": 3.99,
        "description":
            "Silky hot cocoa topped with whipped cream and chocolate shavings."
      }
    },
    {
      "pk": 10,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Fruit Smoothie",
        "price": 4.49,
        "description": "A refreshing blend of fresh fruits, yogurt, and ice."
      }
    },
    {
      "pk": 11,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Café Americano",
        "price": 2.99,
        "description":
            "Espresso with hot water, delivering a bold and robust flavor."
      }
    },
    {
      "pk": 12,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Matcha Latte",
        "price": 4.99,
        "description":
            "Green tea powder mixed with creamy steamed milk, for a vibrant experience."
      }
    },
    {
      "pk": 13,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Iced Latte",
        "price": 4.29,
        "description":
            "Chilled espresso and milk served over ice, the perfect cool-down."
      }
    },
    {
      "pk": 14,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "White Chocolate Mocha",
        "price": 4.99,
        "description":
            "Espresso with white chocolate and whipped cream, pure indulgence."
      }
    },
    {
      "pk": 15,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Decaf Coffee",
        "price": 3.49,
        "description": "A soothing cup of coffee with minimal caffeine content."
      }
    },
    {
      "pk": 16,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Hazelnut Latte",
        "price": 4.79,
        "description":
            "Espresso with steamed milk and a rich hazelnut flavor, a delightful treat."
      }
    }
  ];

  // int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    TextEditingController amountController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String _name = "";
    double _price = 0.0;
    int _amount = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order & borrow'),
        backgroundColor: Color(0xFF377C35),
        foregroundColor: Colors.white,
      ),
      drawer: OnBDrawer(),
      body: SizedBox(
        width: 600,
        child: ListView(
          children: List.generate(
            menuItems.length,
            (index) {
              var menuItem = menuItems[index]['fields'];
              return ResponsiveCard(
                elevation: 5,
                titleGap: 20,
                bgColor: Colors.white,
                screenWidth: 600,
                title: Text(
                  menuItem['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                ),
                subTitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: \$${menuItem['price']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${menuItem['description']}',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 65,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _name = menuItem['name'];
                            _price = menuItem['price'];
                            // print(_name);
                            // print(_price);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // print(_name);
                                // print(_price);
                                return AlertDialog(
                                  title: Text("Order"),
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: amountController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Amount',
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (String? value) {
                                            _amount = int.parse(value!);
                                            // _name = menuItem['name'];
                                            // _price = menuItem['price'];
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Amount must be a valid number!";
                                            }
                                            if (int.tryParse(value) == null) {
                                              return "Amount must be a valid number!";
                                            }
                                            int enteredAmount =
                                                int.tryParse(value) ?? 0;
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
                                        Navigator.pop(context);
                                        _formKey.currentState!.reset();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          // print(_name);
                                          // print(_price);
                                          // String foodName = _name;
                                          // String foodPrice = _price.toString();
                                          // print(
                                          //     '_name before encoding: $_name'); // Add this line
                                          // print(
                                          //     '_price before encoding: $_price');
                                          final response = await request.postJson(
                                              "http://localhost:8000/ordernborrow/guest/order-drink-flutter/",
                                              jsonEncode(<String, String>{
                                                'food_name': _name,
                                                'food_price': _price.toString(),
                                                'amount': _amount.toString(),
                                              }));
                                          if (response['status'] == 'success') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Order berhasil dibuat!"),
                                            ));
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DrinkMenu()),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Terdapat kesalahan, silakan coba lagi."),
                                            ));
                                          }
                                          _formKey.currentState!.reset();
                                        }
                                      },
                                      child: const Text('Order'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            minimumSize: Size(200, 50),
                          ),
                          child: Text(
                            'Order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
