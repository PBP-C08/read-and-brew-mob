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

class FoodMenu extends StatefulWidget {
  @override
  _FoodMenuState createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {
  final List<Map<String, dynamic>> menuItems = [
    {
      "pk": 1,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Bagel with Cream Cheese",
        "price": 2.99,
        "description":
            "A freshly baked bagel served with a generous portion of cream cheese.",
        "picture":
            "https://media.istockphoto.com/id/511742246/sv/foto/bagel-with-cream-cheese.jpg?s=612x612&w=0&k=20&c=fOI0U-WcNVhleIAAMmzEwgZKlDVNEOkBEf7eYjl4jck="
      }
    },
    {
      "pk": 2,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Egg and Cheese Sandwich",
        "price": 4.49,
        "description":
            "A breakfast classic - scrambled eggs and melted cheese on a toasted bun.",
        "picture":
            "https://media.istockphoto.com/id/1187305370/photo/egg-cheese-sandwich.jpg?s=612x612&w=0&k=20&c=o_we1N6rRQmU9bHM42qJQOmXR7iWQPIEAY__DMV4dEg="
      }
    },
    {
      "pk": 3,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Cinnamon Roll",
        "price": 3.49,
        "description": "A sweet and gooey cinnamon roll with icing on top.",
        "picture":
            "https://media.istockphoto.com/id/459034145/photo/homemade-cinnamon-roll-pastry.jpg?s=612x612&w=0&k=20&c=9aSSi1AxAs9q9NrhbGwlOIqMjk1FIN0Dgb4P9rcF4JY="
      }
    },
    {
      "pk": 4,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Chocolate Croissant",
        "price": 2.99,
        "description": "A buttery and flaky croissant mixed with chocolate.",
        "picture":
            "https://media.istockphoto.com/id/1269391551/photo/yummy-freshly-croissant-sliced-almonds-with-chocolate-filling-cut-close-up.jpg?s=612x612&w=0&k=20&c=mLjaw4cpk1aw_d1F9_oNVeybXMZcCcXjKpkibY1F9GU="
      }
    },
    {
      "pk": 5,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "New York Style Pizza",
        "price": 9.99,
        "description":
            "A classic thin-crust pizza with your choice of toppings, just like in the Big Apple.",
        "picture":
            "https://st2.depositphotos.com/1692343/5636/i/450/depositphotos_56360353-stock-photo-hot-homemade-pepperoni-pizza.jpg"
      }
    },
    {
      "pk": 6,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Chicago Deep Dish Pizza",
        "price": 12.99,
        "description":
            "A thick and cheesy deep-dish pizza, a Windy City specialty.",
        "picture":
            "https://media.istockphoto.com/id/466204117/id/foto/chicago-style-deep-dish-cheese-pizza.jpg?s=612x612&w=0&k=20&c=CwaQfXcfVAwCl0-WP2ysRlHVd9xVl9F8taCWQlKtDTI="
      }
    },
    {
      "pk": 7,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Caprese Panini",
        "price": 7.99,
        "description":
            "Fresh mozzarella, ripe tomatoes, and basil pesto on grilled ciabatta bread.",
        "picture":
            "https://media.istockphoto.com/id/930271208/photo/healthy-grilled-basil-mozzarella-caprese-panini.jpg?s=612x612&w=0&k=20&c=6B176_LanoK6okEUU_MCfD49L1W5_dhbFijiJx3FzrM="
      }
    },
    {
      "pk": 8,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Chicken Quesadilla",
        "price": 8.49,
        "description":
            "Sliced chicken, cheese, and vegetables folded in a tortilla and grilled.",
        "picture":
            "https://st2.depositphotos.com/1326558/7214/i/450/depositphotos_72142323-stock-photo-mexican-quesadilla-wraps.jpg"
      }
    },
    {
      "pk": 9,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Spinach and Feta Quiche",
        "price": 6.99,
        "description":
            "A savory pastry filled with spinach, feta cheese, and eggs.",
        "picture":
            "https://media.istockphoto.com/id/535719897/photo/pie-with-spinach-and-feta-cheese.jpg?s=612x612&w=0&k=20&c=pXhqZdXZvI3TqCe8nOUxDyqL85Mr-Z8_BYApjzuhSYg="
      }
    },
    {
      "pk": 10,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Avocado Toast",
        "price": 5.99,
        "description":
            "Sliced avocado on toasted artisan bread, topped with seasoning.",
        "picture":
            "https://media.istockphoto.com/id/1214212184/photo/avocado-and-poached-egg-toast-on-rye-bread-top-view.jpg?s=612x612&w=0&k=20&c=BhHMua211VCgMHZBaphoYY3WjWVG9ZkMbfJQgsPbzVs="
      }
    },
    {
      "pk": 11,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Muffin",
        "price": 2.49,
        "description": "A freshly baked muffin in your choice of flavor.",
        "picture":
            "https://media.istockphoto.com/id/516688047/photo/homemade-autumn-pumpkin-muffin.jpg?s=612x612&w=0&k=20&c=wbzrNN3oX-F4Q1rZJAeDLH9EKJfnHk9yyaJqIJbkV_U="
      }
    },
    {
      "pk": 12,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Blueberry Scone",
        "price": 2.79,
        "description":
            "A tender and crumbly scone filled with juicy blueberries.",
        "picture":
            "https://media.istockphoto.com/id/1438178299/photo/homemade-berry-scones.jpg?s=612x612&w=0&k=20&c=APpHucIYD5f03YgUPHJuigcyaW5nSAYlOH8KfoXTPDw="
      }
    },
    {
      "pk": 13,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Breakfast Burrito",
        "price": 6.49,
        "description":
            "A hearty breakfast burrito filled with eggs, sausage, cheese, and vegetables.",
        "picture":
            "https://media.istockphoto.com/id/1303481589/photo/sausage-and-egg-breakfast-burrito.jpg?s=612x612&w=0&k=20&c=I7U70VnoMB35GVZjT3zO9auDEAmh8X_xRJXATvbJ4Fk="
      }
    },
    {
      "pk": 14,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Fruit Parfait",
        "price": 4.99,
        "description":
            "A delicious parfait made with yogurt, granola, and a mix of fresh fruits.",
        "picture":
            "https://media.istockphoto.com/id/639376412/photo/blueberry-raspberry-parfaits-in-mason-jars-still-life-against-wood.jpg?s=612x612&w=0&k=20&c=3eBFSWTyRnAsa0MPlsLbjaZAQQZJIao8zmc_9oKy-po="
      }
    },
    {
      "pk": 15,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Quiche Lorraine",
        "price": 6.99,
        "description":
            "A classic quiche filled with bacon, Swiss cheese, and a savory custard.",
        "picture":
            "https://media.istockphoto.com/id/469583525/id/foto/quiche-lorraine.jpg?s=612x612&w=0&k=20&c=oQSOOwMV0Apgy6OQdllc53V3II3N-0FpLQaAnQ8WSCo="
      }
    },
    {
      "pk": 16,
      "model": "ordernborrow.Food",
      "fields": {
        "name": "Veggie Wrap",
        "price": 5.99,
        "description":
            "A delicious wrap filled with assorted vegetables and a flavorful dressing.",
        "picture":
            "https://media.istockphoto.com/id/941025092/photo/chicken-wraps.jpg?s=612x612&w=0&k=20&c=MVwZVtHifhEhbkxVyYDxbEo8El7NInTsa7TW_qv8I0k="
      }
    }
  ];

  Future<void> _placeOrder(BuildContext context, CookieRequest request,
      String _name, double _price, int _amount) async {
    final response = await request.postJson(
        "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/guest/order-food-flutter/",
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
        title: user_id == 0
            ? const Text('Order & Borrow - Food',
                style: TextStyle(fontWeight: FontWeight.bold))
            : const Text('Order - Food',
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
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
                                          if (user_id == 0) {
                                            _placeOrder(context, request, _name,
                                                _price, _amount);
                                          } else {
                                            _placeOrderMember(context, request,
                                                _name, _price, _amount);
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
