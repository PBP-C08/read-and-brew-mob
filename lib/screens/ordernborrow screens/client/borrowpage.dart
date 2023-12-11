import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/books.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/borrowedbooks.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/borrowedhistory.dart';
import 'package:flutter/src/widgets/framework.dart';

int indexBorrow = 0;

class BorrowPage extends StatefulWidget {
  final kategori;
  final search;
  final sort;
  final order;
  const BorrowPage(this.kategori, this.search, this.sort, this.order,
      {Key? key})
      : super(key: key);
  _BorrowPageState createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  final List<Widget> _pagesBorrow = [
    BooksPage("", "", "", ""),
    BorrowedBooks("", "", "", ""),
    BorrowedHistoryPage("", "", "", ""),
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
          if (index == indexBorrow) {
            indexBorrow = index;
            judul_found = '';
            kategori_found = '';
            sort_found = '';
            order_found = '';
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BorrowPage("", "", "", "")),
            );
          } else {
            setState(() {
              indexBorrow = index;
              judul_found = '';
              kategori_found = '';
              sort_found = '';
              order_found = '';
            });
          }
        },
      ),
    );
  }
}
