import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/drinkmenu.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/foodmenu.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/ordermembersummary.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/ordersummary.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/secretmenu.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    FoodMenu(),
    DrinkMenu(),
    const OrderSummaryPage(),
  ];

  final List<Widget> _pagesMember = [
    FoodMenu(),
    DrinkMenu(),
    SecretMenu(),
    const OrderMemberPage(),
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant),
        label: 'Food',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.local_cafe),
        label: 'Drinks',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long),
        label: 'Order Summary',
      ),
    ];

    if (user_id != 0) {
      bottomNavBarItems = [
        const BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'Food',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.local_cafe),
          label: 'Drinks',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.lock),
          label: 'Secret Menu',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Order Summary',
        ),
      ];
    }

    return Scaffold(
      body: user_id == 0 ? _pages[_currentIndex] : _pagesMember[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xFF377C35),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
