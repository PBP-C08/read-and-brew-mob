import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/guest/drinkmenu.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/guest/ordersummary.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';
import 'package:responsive_card/responsive_card.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class FoodMenu extends StatefulWidget {
  @override
  _FoodMenuState createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    FoodMenu(),
    DrinkMenu(),
    OrderPage(),
  ];

  final List<Map<String, dynamic>> menuItems = [
    {
      "pk": 1,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Bagel with Cream Cheese",
        "price": 2.99,
        "description":
            "A freshly baked bagel served with a generous portion of cream cheese."
      }
    },
    {
      "pk": 2,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Egg and Cheese Sandwich",
        "price": 4.49,
        "description":
            "A breakfast classic - scrambled eggs and melted cheese on a toasted bun."
      }
    },
    {
      "pk": 3,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Cinnamon Roll",
        "price": 3.49,
        "description": "A sweet and gooey cinnamon roll with icing on top."
      }
    },
    {
      "pk": 4,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Chocolate Croissant",
        "price": 2.99,
        "description": "A buttery and flaky croissant mixed with chocolate."
      }
    },
    {
      "pk": 5,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "New York Style Pizza",
        "price": 9.99,
        "description":
            "A classic thin-crust pizza with your choice of toppings, just like in the Big Apple."
      }
    },
    {
      "pk": 6,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Chicago Deep Dish Pizza",
        "price": 12.99,
        "description":
            "A thick and cheesy deep-dish pizza, a Windy City specialty."
      }
    },
    {
      "pk": 7,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Caprese Panini",
        "price": 7.99,
        "description":
            "Fresh mozzarella, ripe tomatoes, and basil pesto on grilled ciabatta bread."
      }
    },
    {
      "pk": 8,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Chicken Quesadilla",
        "price": 8.49,
        "description":
            "Sliced chicken, cheese, and vegetables folded in a tortilla and grilled."
      }
    },
    {
      "pk": 9,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Spinach and Feta Quiche",
        "price": 6.99,
        "description":
            "A savory pastry filled with spinach, feta cheese, and eggs."
      }
    },
    {
      "pk": 10,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Avocado Toast",
        "price": 5.99,
        "description":
            "Sliced avocado on toasted artisan bread, topped with seasoning."
      }
    },
    {
      "pk": 11,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Muffin",
        "price": 2.49,
        "description": "A freshly baked muffin in your choice of flavor."
      }
    },
    {
      "pk": 12,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Blueberry Scone",
        "price": 2.79,
        "description":
            "A tender and crumbly scone filled with juicy blueberries."
      }
    },
    {
      "pk": 13,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Breakfast Burrito",
        "price": 6.49,
        "description":
            "A hearty breakfast burrito filled with eggs, sausage, cheese, and vegetables."
      }
    },
    {
      "pk": 14,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Fruit Parfait",
        "price": 4.99,
        "description":
            "A delicious parfait made with yogurt, granola, and a mix of fresh fruits."
      }
    },
    {
      "pk": 15,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Quiche Lorraine",
        "price": 6.99,
        "description":
            "A classic quiche filled with bacon, Swiss cheese, and a savory custard."
      }
    },
    {
      "pk": 16,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Veggie Wrap",
        "price": 5.99,
        "description":
            "A delicious wrap filled with assorted vegetables and a flavorful dressing."
      }
    }
  ];
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
        title: const Text('Order & Borrow - Food'),
        backgroundColor: Color(0xFF377C35),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
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
                                          final response = await request.postJson(
                                              "http://localhost:8000/ordernborrow/guest/order-food-flutter/",
                                              jsonEncode(<String, String>{
                                                'food_name': _name,
                                                'food_price': _price.toString(),
                                                'amount': _amount.toString(),
                                              }));
                                          if (response['status'] == 'success') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Order successfully placed!"),
                                            ));
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FoodMenu()),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Sorry there seems to be a problem, please try again."),
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

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _pages[_currentIndex]),
          );
        },
      ),
    );
  }
}
