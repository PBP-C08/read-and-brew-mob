import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/booklist_detail.dart';
import 'package:read_and_brew/screens/booklist_form.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BooklistPage extends StatefulWidget {
  const BooklistPage({Key? key}) : super(key: key);

  @override
  _BooklistPageState createState() => _BooklistPageState();
}

class _BooklistPageState extends State<BooklistPage> {
  List<String> list_kategori = [];
  List<Buku> _list_book = [];
  List<Buku>? _list_show = [];
  String? selectedCategory = "All";
  String searchText = "";

  Future<List<Buku>> fetchItem() async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Buku> list_item = [];

    for (var d in data) {
      if (d != null) {
        list_item.add(Buku.fromJson(d));
      }
    }

    for (var d in list_item) {
      list_kategori.add(d.fields.kategori);
    }
    list_kategori = list_kategori.toSet().toList();

    return list_item;
  }

  @override
  void initState() {
    fetchItem().then((value) {
      setState(() {
        _list_book.addAll(value);
        _list_show = _list_book;
      });
    }).catchError((error) {
      if (error is ClientException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terdapat kesalahan pada server/jaringan internet'),
          ),
        );
        setState(() {
          _list_show = null;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Book List',
            style: TextStyle(
                color: Color(0xFF377C35), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: user_status == "E"
              ? [
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF377C35)),
                    ),
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BooklistFormPage(list_kategori)));
                    },
                  ),
                ]
              : null,
          foregroundColor: Color(0xFF377C35),
        ),
        drawer: const LeftDrawer(),
        body: _list_show == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('images/logo.png'),
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Server/Network Error',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (text) {
                        text = text.toLowerCase();
                        setState(() {
                          searchText = text;
                          _list_show = _list_book.where((book) {
                            var bookTitle = book.fields.judul.toLowerCase();
                            var bookKategori = book.fields.kategori;
                            selectedCategory = selectedCategory == 'All'
                                ? null
                                : selectedCategory;
                            return bookTitle.contains(text) &&
                                (selectedCategory == null ||
                                    bookKategori == selectedCategory);
                          }).toList();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide:
                              BorderSide(color: Color(0xFF377C35), width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide:
                              BorderSide(color: Color(0xFF377C35), width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      decoration: InputDecoration(
                        labelText: "Kategori",
                        hintText: "Kategori",
                        prefixIcon: Icon(Icons.list),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide:
                              BorderSide(color: Color(0xFF377C35), width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide:
                              BorderSide(color: Color(0xFF377C35), width: 1.0),
                        ),
                      ),
                      value: "All",
                      items: ['All', ...list_kategori]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value == 'All' ? null : value;
                          _list_show = _list_book.where((book) {
                            var bookTitle = book.fields.judul.toLowerCase();
                            var bookKategori = book.fields.kategori;
                            return bookTitle.contains(searchText) &&
                                (selectedCategory == null ||
                                    bookKategori == selectedCategory);
                          }).toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                      child: _list_show?.length == 0
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Belum ada buku.",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(12.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: (1 / 1.5),
                              ),
                              itemCount: _list_show?.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Color.fromARGB(255, 235, 255, 235),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: Color(0xFF377C35),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetailPage(
                                                _list_show![index].pk,
                                                _list_show![index]
                                                    .fields
                                                    .gambar,
                                                _list_show![index].fields.judul,
                                                _list_show![index]
                                                    .fields
                                                    .rating,
                                                _list_show![index]
                                                    .fields
                                                    .kategori,
                                                _list_show![index]
                                                    .fields
                                                    .penulis,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                _list_show![index]
                                                    .fields
                                                    .gambar,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Icon(Icons.error);
                                                },
                                                width: 200,
                                                height: 200,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                _list_show![index].fields.judul,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8),
                                              RatingBar.builder(
                                                initialRating:
                                                    _list_show![index]
                                                        .fields
                                                        .rating
                                                        .toDouble(),
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemSize: 20,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                ignoreGestures: true,
                                                onRatingUpdate:
                                                    (double value) {},
                                              ),
                                              const SizedBox(height: 8),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'Kategori: ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _list_show![index]
                                                          .fields
                                                          .kategori,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'Penulis: ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _list_show![index]
                                                          .fields
                                                          .penulis,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              })),
                ],
              ));
  }
}
