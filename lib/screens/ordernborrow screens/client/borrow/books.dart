import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/booksdetail.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/borrowedbooks.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/borrowedhistory.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';

class BooksPage extends StatefulWidget {
  final kategori;
  final search;
  final sort;
  final order;
  const BooksPage(this.kategori, this.search, this.sort, this.order, {Key? key})
      : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final _formKey = GlobalKey<FormState>();
  String _judul = "";
  String _kategori = "";
  String _penulis = "";
  String _gambar = "";
  List<String> list_kategori = [];
  String judul_search = '';
  String kategori_search = '';
  String sort_search = '';
  List<String> sort_by = ["Judul", "Rating"];
  String order_search = '';

  int _currentIndex = 0;
  final List<Widget> _pagesBorrow = [
    BooksPage("", "", "", ""),
    BorrowedBooks("", "", "", ""),
    BorrowedHistoryPage("", "", "", ""),
  ];

  Future<List<Buku>> fetchAvailableBooks() async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Buku> list_item = [];
    List<Buku> list_show = [];
    for (var d in data) {
      if (d != null) {
        list_item.add(Buku.fromJson(d));
      }
    }

    var borrowedBooksUrl = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/ordernborrow/member/borrowed/');
    var borrowedBooksResponse = await http.get(
      borrowedBooksUrl,
      headers: {"Content-Type": "application/json"},
    );
    var borrowedBooksData =
        jsonDecode(utf8.decode(borrowedBooksResponse.bodyBytes));
    List<int> borrowedBookIds = borrowedBooksData
        .map<int>((item) => item['fields']['book'] as int)
        .toList();

    for (var d in list_item) {
      if (!borrowedBookIds.contains(d.pk)) {
        list_show.add(d);
      }
    }

    if (widget.kategori != "") {
      list_show = list_show
          .where((book) =>
              book.fields.kategori == widget.kategori &&
              book.fields.judul
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()))
          .toList();
    } else {
      list_show = list_show
          .where((book) => book.fields.judul
              .toLowerCase()
              .contains(widget.search.toLowerCase()))
          .toList();
    }

    if (widget.sort == "Judul") {
      list_show.sort((a, b) =>
          a.fields.judul.toLowerCase().compareTo(b.fields.judul.toLowerCase()));
    } else if (widget.sort == "Rating") {
      list_show.sort((a, b) => a.fields.rating.compareTo(b.fields.rating));
    }

    for (var d in list_item) {
      list_kategori.add(d.fields.kategori);
    }
    list_kategori = list_kategori.toSet().toList();
    return list_show;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: const Color(0xFF377C35),
        foregroundColor: Colors.white,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40,
                                top: -40,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Title",
                                          labelText: "Title",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            judul_search = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RawAutocomplete(
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                String>.empty();
                                          } else {
                                            List<String> matches = <String>[];
                                            matches.addAll(list_kategori);

                                            matches.retainWhere((s) {
                                              return s.toLowerCase().contains(
                                                  textEditingValue.text
                                                      .toLowerCase());
                                            });
                                            return matches;
                                          }
                                        },
                                        onSelected: (String selection) {},
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextFormField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              hintText: "Category",
                                              labelText: "Category",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onChanged: (String value) {
                                              setState(() {
                                                kategori_search = value;
                                              });
                                            },
                                          );
                                        },
                                        optionsViewBuilder: (BuildContext
                                                context,
                                            void Function(String) onSelected,
                                            Iterable<String> options) {
                                          return Material(
                                            child: SizedBox(
                                              height: 200,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: options.map((opt) {
                                                    return InkWell(
                                                      onTap: () {
                                                        kategori_search = opt;
                                                        onSelected(opt);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 60),
                                                        child: Card(
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Text(opt),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownMenu<String>(
                                        label: Text("Sort by"),
                                        hintText: "Sort by",
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        requestFocusOnTap: false,
                                        onSelected: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            sort_search = value!;
                                          });
                                        },
                                        dropdownMenuEntries: sort_by
                                            .map<DropdownMenuEntry<String>>(
                                                (String value) {
                                          return DropdownMenuEntry<String>(
                                              value: value, label: value);
                                        }).toList(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                        ),
                                        child: const Text('Search',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BooksPage(
                                                          kategori_search,
                                                          judul_search,
                                                          sort_search,
                                                          order_search)),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: const OnBDrawer(),
      body: FutureBuilder(
          future: fetchAvailableBooks(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data!.length == 0) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Book doesn't exist.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => ListTile(
                    leading: Image.network(
                      snapshot.data![index].fields.gambar,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                    title: Text(snapshot.data![index].fields.judul),
                    subtitle: Text(snapshot.data![index].fields.kategori),
                    trailing: RatingBar.builder(
                      initialRating: snapshot.data![index].fields.rating,
                      minRating: 0,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 15.0,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (double value) {},
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BooksDetails(
                              snapshot.data![index].pk,
                              snapshot.data![index].fields.gambar,
                              snapshot.data![index].fields.judul,
                              snapshot.data![index].fields.rating,
                              snapshot.data![index].fields.kategori,
                              snapshot.data![index].fields.penulis,
                              "NO"),
                        ),
                      );
                    },
                  ),
                );
              }
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xFF377C35),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => _pagesBorrow[_currentIndex]),
          );
        },
      ),
    );
  }
}
