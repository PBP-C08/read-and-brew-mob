import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';
import 'package:responsive_card/responsive_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class DrinkMenu extends StatefulWidget {
  @override
  _DrinkMenuState createState() => _DrinkMenuState();
}

class _DrinkMenuState extends State<DrinkMenu> {
  final List<Map<String, dynamic>> menuItems = [
    {
      "pk": 1,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Latte",
        "price": 3.99,
        "description":
            "Espresso with creamy steamed milk and a hint of vanilla.",
        "picture":
            "https://media.istockphoto.com/id/482528386/photo/cup-of-heart-latte-art.jpg?s=612x612&w=0&k=20&c=SfcHG-rkmGSvnm-AOsWDj63fH046qPPMMKsC5_cw-EI="
      }
    },
    {
      "pk": 2,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Cappuccino",
        "price": 4.49,
        "description":
            "Espresso topped with frothy milk and a sprinkle of cocoa.",
        "picture":
            "https://media.istockphoto.com/id/173245886/id/foto/cappuccino.jpg?s=612x612&w=0&k=20&c=2Cw2XvVc4FEMIYDypViuKHPLE65np0iEScaZcI6o80U="
      }
    },
    {
      "pk": 3,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Mocha",
        "price": 4.99,
        "description":
            "Rich espresso with velvety steamed milk, cocoa, and whipped cream.",
        "picture":
            "https://media.istockphoto.com/id/953747804/photo/iced-mocha-coffee-with-whip-cream-summer-drinking-times-coffee-beans-rustic-textured-wooden.jpg?s=612x612&w=0&k=20&c=2PXJdteWQ9K5OPfARixdMt4XOJr7NqU-QlFVjwyMCFs="
      }
    },
    {
      "pk": 4,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Iced Coffee",
        "price": 3.49,
        "description":
            "Chilled coffee brewed to perfection, served with ice cubes.",
        "picture":
            "https://media.istockphoto.com/id/1366850534/photo/glass-of-a-iced-coffee-with-cream-milk-cold-brew-coffee-drink-with-ice.jpg?s=612x612&w=0&k=20&c=1ZN8z8n-Yo2LpN7gBPGw3fw8QDLAWfsA0vbkeV1z8dg="
      }
    },
    {
      "pk": 5,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Espresso",
        "price": 2.49,
        "description":
            "A shot of intense, concentrated coffee to awaken your senses.",
        "picture":
            "https://media.istockphoto.com/id/1302454454/photo/espresso-coffee-with-coffee-beans-in-the-morning-background.jpg?s=612x612&w=0&k=20&c=OMh6AjTjOSYINI6U-4nGea9_wrycorw2rWq0H3EEjrY="
      }
    },
    {
      "pk": 6,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Chai Latte",
        "price": 4.99,
        "description":
            "Spiced black tea combined with frothy milk for a delightful balance.",
        "picture":
            "https://media.istockphoto.com/id/1221489771/photo/chai-latte-in-glass-with-milk.jpg?s=612x612&w=0&k=20&c=zsUZOKNQDM6u1vn8hM62HVzYn7QrEAN7OPymyAx6yo0="
      }
    },
    {
      "pk": 7,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Caramel Macchiato",
        "price": 4.99,
        "description":
            "Espresso with steamed milk, caramel, and a caramel drizzle.",
        "picture":
            "https://st3.depositphotos.com/6676810/14547/i/450/depositphotos_145473173-stock-photo-ice-caramel-macchato.jpg"
      }
    },
    {
      "pk": 8,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Iced Tea",
        "price": 3.29,
        "description":
            "Chilled tea infused with fruit essence, served over ice.",
        "picture":
            "https://media.istockphoto.com/id/497897321/photo/homemade-iced-tea-with-lemons.jpg?s=612x612&w=0&k=20&c=IYx_qxksqCK1_P_VgETpOka838u1kBqwP4N99lXB2uU="
      }
    },
    {
      "pk": 9,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Hot Chocolate",
        "price": 3.99,
        "description":
            "Silky hot cocoa topped with whipped cream and chocolate shavings.",
        "picture":
            "https://media.istockphoto.com/id/1320380734/photo/homemade-warm-hot-chocolate.jpg?s=612x612&w=0&k=20&c=DYi2DzE8KDjFAndmesptb5R5fxKRuGXdya60lFZKha4="
      }
    },
    {
      "pk": 10,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Fruit Smoothie",
        "price": 4.49,
        "description": "A refreshing blend of fresh fruits, yogurt, and ice.",
        "picture":
            "https://media.istockphoto.com/id/1081369140/photo/healthy-appetizing-red-smoothie-dessert-in-glasses.jpg?s=612x612&w=0&k=20&c=ayAj4LQwwNIdY3aJ7fmzzG4HP_vtGboSeiP-FFO6Wm8="
      }
    },
    {
      "pk": 11,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Café Americano",
        "price": 2.99,
        "description":
            "Espresso with hot water, delivering a bold and robust flavor.",
        "picture":
            "https://media.istockphoto.com/id/1030018926/photo/coffee-americano-it-made-from-espresso-and-hot-water-uk.jpg?s=612x612&w=0&k=20&c=trsNtjalA6r9eGka845eO1nYOP0yogvLWqBAg-jsBlM="
      }
    },
    {
      "pk": 12,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Matcha Latte",
        "price": 4.99,
        "description":
            "Green tea powder mixed with creamy steamed milk, for a vibrant experience.",
        "picture":
            "https://media.istockphoto.com/id/1325991061/photo/matcha-latte-green-milk-foam-cup-on-wood-table-at-cafe-trendy-powered-tea-trend-from-japan.jpg?s=612x612&w=0&k=20&c=a7cV9mdPwPj93BrxoFrJXEdA71RsOnXIOzVF90CYPsQ="
      }
    },
    {
      "pk": 13,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Iced Latte",
        "price": 4.29,
        "description":
            "Chilled espresso and milk served over ice, the perfect cool-down.",
        "picture":
            "https://media.istockphoto.com/id/1218361895/photo/two-glasses-of-iced-coffee-on-a-light-concrete-table.jpg?s=612x612&w=0&k=20&c=WOCjzlBhEhrav2BKk7x1TJeFy4WF2_60KVyVkY6OtGI="
      }
    },
    {
      "pk": 14,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "White Chocolate Mocha",
        "price": 4.99,
        "description":
            "Espresso with white chocolate and whipped cream, pure indulgence.",
        "picture":
            "https://media.istockphoto.com/id/1330584216/photo/white-chocolate-latte-topped-with-whipped-cream-and-cocoa-powder.jpg?s=612x612&w=0&k=20&c=hm9PSljnkxP-gHsB-3OSbObAHxyvA-qQ6l7WEBU7eUo="
      }
    },
    {
      "pk": 15,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Decaf Coffee",
        "price": 3.49,
        "description":
            "A soothing cup of coffee with minimal caffeine content.",
        "picture":
            "https://media.istockphoto.com/id/1299044033/photo/coffee-cup-and-coffee-beans-on-wooden-table.jpg?s=612x612&w=0&k=20&c=FhIX03NoGHbpPpgbXd1H2BxQbQaEau7Ma6-VtrQTCks="
      }
    },
    {
      "pk": 16,
      "model": "ordernborrow.Drink",
      "fields": {
        "name": "Hazelnut Latte",
        "price": 4.79,
        "description":
            "Espresso with steamed milk and a rich hazelnut flavor, a delightful treat.",
        "picture":
            "https://media.istockphoto.com/id/1247810487/photo/diverse-keto-dishes.jpg?s=612x612&w=0&k=20&c=pbUTkBk2O2pAhAlSoLLQK6ZgYnvGBceo2gYpDOVBmEM="
      }
    }
  ];

  Future<void> _placeOrder(BuildContext context, CookieRequest request,
      String _name, double _price, int _amount) async {
    final response = await request.postJson(
        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/guest/order-drink-flutter/",
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

  Future<void> _placeOrderMember(BuildContext context, CookieRequest request,
      String _name, double _price, int _amount) async {
    final response = await request.postJson(
        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/member/order-drink-flutter/",
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
        title: user_id == 0
            ? const Text('Order & Borrow - Drinks',
                style: TextStyle(fontWeight: FontWeight.bold))
            : const Text('Order - Drinks',
                style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: const Color(0xFF377C35),
        backgroundColor: Colors.white,
      ),
      drawer: user_id != 0 && user_status == "M"
          ? const OnBDrawer()
          : const LeftDrawer(),
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
                action: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        menuItem['picture'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
                                          // GUEST
                                          if (user_id == 0) {
                                            _placeOrder(context, request, _name,
                                                _price, _amount);
                                          } else {
                                            if (user_status == "M") {
                                              _placeOrderMember(
                                                  context,
                                                  request,
                                                  _name,
                                                  _price,
                                                  _amount);
                                            }
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
                            minimumSize: const Size(200, 50),
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
