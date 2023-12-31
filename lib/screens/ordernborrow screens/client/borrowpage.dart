import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/books.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/borrowedbooks.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/borrowedhistory.dart';

int indexBorrow = 0;

class BorrowPage extends StatefulWidget {
  const BorrowPage({Key? key}) : super(key: key);
  @override
  _BorrowPageState createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  final List<Widget> _pagesBorrow = [
    const BooksPage(),
    const BorrowedBooks(),
    const BorrowedHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.menu_book),
        label: 'Books',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.auto_stories),
        label: 'Borrowed',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.import_contacts),
        label: 'History',
      ),
    ];

    return Scaffold(
      body: _pagesBorrow[indexBorrow],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xFF377C35),
        currentIndex: indexBorrow,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            indexBorrow = index;
            judul_found = '';
            kategori_found = '';
            sort_found = '';
            order_found = '';
          });
        },
      ),
    );
  }
}
