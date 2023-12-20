import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/bookrequest_all.dart';
import 'package:read_and_brew/screens/bookrequest_individual.dart';
import 'package:read_and_brew/screens/bookrequest_addrequest.dart';
import 'package:read_and_brew/screens/login.dart';

class RequestBukuPage extends StatefulWidget {
  @override
  _RequestBukuPageState createState() => _RequestBukuPageState();
}

class _RequestBukuPageState extends State<RequestBukuPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    RequestBukuAllPage(),
    AddRequestPage(),
    RequestBukuIndividualPage(),
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavBarItems = [];

    if (user_status == 'M') {
      bottomNavBarItems = [
        const BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'All Request',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Request',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.private_connectivity),
          label: 'Your Request',
        )
      ];
    } else {
      _currentIndex = 0; // Set the index to 0 for RequestBukuAllPage() when user status is not 'M'
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: user_status == 'M'
          ? BottomNavigationBar(
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
            )
          : null,
    );
  }
}