import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/borrow/booksdetail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';

String judul_found = '';
String kategori_found = '';
String sort_found = '';
String order_found = '';

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late Future<List<Buku>> futureBooks;
  final _formKey = GlobalKey<FormState>();
  List<String> list_kategori = [];
  List<String> sort_by = ["Judul", "Rating"];
  bool isSearched = false;
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchAvailableBooks();
  }

  Future<void> refreshBooksData() async {
    final newBooksData = await fetchAvailableBooks();
    setState(() {
      futureBooks = Future.value(newBooksData);
    });
  }

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

    if (kategori_found != "") {
      list_show = list_show
          .where((book) =>
              book.fields.kategori == kategori_found &&
              book.fields.judul
                  .toLowerCase()
                  .contains(judul_found.toLowerCase()))
          .toList();
    } else {
      list_show = list_show
          .where((book) => book.fields.judul
              .toLowerCase()
              .contains(judul_found.toLowerCase()))
          .toList();
    }

    if (sort_found == "Judul") {
      list_show.sort((a, b) =>
          a.fields.judul.toLowerCase().compareTo(b.fields.judul.toLowerCase()));
    } else if (sort_found == "Rating") {
      list_show.sort((a, b) => a.fields.rating.compareTo(b.fields.rating));
    }

    for (var d in list_item) {
      list_kategori.add(d.fields.kategori);
    }
    list_kategori = list_kategori.toSet().toList();
    judul_found = '';
    kategori_found = '';
    sort_found = '';
    order_found = '';
    return list_show;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Books', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: const Color(0xFF377C35),
        backgroundColor: Colors.white,
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
                                    isFilled = false;
                                    isSearched = false;
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
                                            judul_found = value!;
                                            isFilled = true;
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
                                                kategori_found = value;
                                                isFilled = true;
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
                                                        kategori_found = opt;
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
                                          setState(() {
                                            sort_found = value!;
                                            isFilled = true;
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
                                            Navigator.pop(context);
                                            if (judul_found.isEmpty &&
                                                kategori_found.isEmpty &&
                                                sort_found.isEmpty) {
                                              isFilled = false;
                                            }
                                            isSearched = true;
                                            refreshBooksData();
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: futureBooks,
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
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                        title: Text(
                          snapshot.data![index].fields.judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(snapshot.data![index].fields.kategori),
                        trailing: RatingBar.builder(
                          initialRating:
                              snapshot.data![index].fields.rating.toDouble(),
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
                                "NO",
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
          if (isFilled && isSearched)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSearched = false;
                    isFilled = false;
                  });
                  refreshBooksData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF377C35),
                ),
                child: const Text(
                  'Clear Filter',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
