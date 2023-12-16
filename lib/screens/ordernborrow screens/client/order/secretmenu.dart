// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';
import 'package:responsive_card/responsive_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class SecretMenu extends StatefulWidget {
  @override
  _SecretMenuState createState() => _SecretMenuState();
}

class _SecretMenuState extends State<SecretMenu> {
  final List<Map<String, dynamic>> menuItems = [
    {
      "pk": 1,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Mystery Meatball Sub",
        "price": 5.99,
        "description":
            "Indulge in succulent meatballs smothered in rich marinara sauce, tucked into a warm sub roll with a surprising twist."
      }
    },
    {
      "pk": 2,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Stealthy Spinach Salad",
        "price": 6.49,
        "description":
            "Discover a secret blend of fresh ingredients in a vibrant spinach salad that's a hidden gem on the menu."
      }
    },
    {
      "pk": 3,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Undercover Veggie Wrap",
        "price": 7.99,
        "description":
            "Embark on a culinary adventure with a veggie wrap featuring a secret sauce that adds a delightful kick."
      }
    },
    {
      "pk": 4,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Intrigue Italian Pasta",
        "price": 8.49,
        "description":
            "Savor a top-secret Italian pasta dish, expertly prepared with a balance of bold and delightful flavors."
      }
    },
    {
      "pk": 5,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Hidden Hummus Platter",
        "price": 9.99,
        "description":
            "Whisper the secret password and relish a hummus platter adorned with an array of concealed toppings, perfect for sharing."
      }
    },
    {
      "pk": 6,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Classified Cheeseburger",
        "price": 4.49,
        "description":
            "Uncover the mystery of a classic cheeseburger with an intriguing twist that will leave your taste buds guessing."
      }
    },
    {
      "pk": 7,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Covert Caramel Latte",
        "price": 5.99,
        "description":
            "Experience the allure of a caramel latte, where sweetness meets velvety espresso in a delightful rendezvous."
      }
    },
    {
      "pk": 8,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Stealthy Strawberry Smoothie",
        "price": 6.49,
        "description":
            "Delight in a secret blend of fresh strawberries and creamy yogurt, with a hint of enchantment that will whisk you away."
      }
    },
    {
      "pk": 9,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Undercover Coconut Mocha",
        "price": 7.99,
        "description":
            "Unearth the hidden tropical delight of a mocha, where rich coffee meets the lusciousness of coconut in an unexpected combination."
      }
    },
    {
      "pk": 10,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Espionage Espresso Con Panna",
        "price": 8.49,
        "description":
            "Embark on a covert mission with an espresso that's topped with a luxurious dollop of whipped cream, an indulgent treat shrouded in secrecy."
      }
    },
    {
      "pk": 11,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Intrigue Iced Chai",
        "price": 9.99,
        "description":
            "Unlock the secret and enjoy an iced chai latte, crafted with a special blend of spices that will captivate your taste buds."
      }
    },
    {
      "pk": 12,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Classified Cold Brew",
        "price": 4.49,
        "description":
            "Discover the well-aged mystery of a cold brew, where time and precision create a coffee masterpiece that's aged to perfection."
      }
    }
  ];

  Future<void> _placeOrderMember(BuildContext context, CookieRequest request,
      String _name, double _price, int _amount) async {
    final response = await request.postJson(
        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/member/order-food-flutter/",
        jsonEncode(<String, String>{
          'food_name': _name,
          'food_price': _price.toString(),
          'amount': _amount.toString(),
        }));
    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Order successfully placed!"),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sorry there seems to be a problem, please try again."),
      ));
      Navigator.pop(context);
    }
  }

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
        title: const Text('Order - Secret Menu',
            style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: const Color(0xFF377C35),
        backgroundColor: Colors.white,
      ),
      drawer: const OnBDrawer(),
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 21),
                ),
                subTitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: \$${menuItem['price']}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${menuItem['description']}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 65,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _name = menuItem['name'];
                            _price = menuItem['price'];
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Order"),
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
                                          decoration: const InputDecoration(
                                            labelText: 'Amount',
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _amount = int.parse(value!);
                                            });
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
                                          _placeOrderMember(context, request,
                                              _name, _price, _amount);
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
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: Size(200, 50),
                          ),
                          child: const Text(
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
