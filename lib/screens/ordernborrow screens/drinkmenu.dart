import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';

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

  void _makeOrder(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    String _name = "";
    int _price = 0;
    int _amount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order"),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {}
              },
              child: const Text('Order'),
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
        title: const Text('Order & borrow'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: OnBDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of items in each row
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
          ),
          itemCount: menuItems.length,
          itemBuilder: (BuildContext context, int index) {
            var menuItem = menuItems[index]['fields'];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      menuItem['name'],
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Price: \$${menuItem['price']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${menuItem['description']}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Add your order logic here
                            _makeOrder(context);
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
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
