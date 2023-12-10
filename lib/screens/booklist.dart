import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:read_and_brew/models/buku.dart';
import 'package:read_and_brew/screens/booklist_detail.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/screens/login.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BooklistPage extends StatefulWidget {
  final kategori;
  final search;
  final sort;
  final order;
  const BooklistPage(this.kategori, this.search, this.sort, this.order,
      {Key? key})
      : super(key: key);

  @override
  _BooklistPageState createState() => _BooklistPageState();
}

class _BooklistPageState extends State<BooklistPage> {
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
  Future<List<Buku>> fetchItem() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/api/buku/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Buku> list_item = [];
    List<Buku> list_show = [];
    for (var d in data) {
      if (d != null) {
        list_item.add(Buku.fromJson(d));
      }
    }
    if (widget.kategori == "") {
      for (var d in list_item) {
        if (d.fields.judul
            .toLowerCase()
            .contains(widget.search.toLowerCase())) {
          list_show.add(d);
        }
      }
    } else {
      for (var d in list_item) {
        if (d.fields.kategori == widget.kategori &&
            d.fields.judul
                .toLowerCase()
                .contains(widget.search.toLowerCase())) {
          list_show.add(d);
        }
      }
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
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Book List',
            ),
          ),
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
                                            hintText: "Judul",
                                            labelText: "Judul",
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
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              TextEditingController
                                                  textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted) {
                                            return TextFormField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                hintText: "Kategori",
                                                labelText: "Kategori",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
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
                                                    children:
                                                        options.map((opt) {
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
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
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
                                          child: const Text('Submit',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BooklistPage(
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
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchItem(),
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
                          "Belum ada buku.",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20),
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
                          // You can return any widget here. For example, let's return an Icon.
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
                        itemSize:
                            15.0, // Adjust this value to change the size of the stars
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
                            builder: (context) => BookDetailPage(
                              snapshot.data![index].pk,
                              snapshot.data![index].fields.gambar,
                              snapshot.data![index].fields.judul,
                              snapshot.data![index].fields.rating,
                              snapshot.data![index].fields.kategori,
                              snapshot.data![index].fields.penulis,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            }),
        bottomNavigationBar: user_status == "E"
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
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
                                                hintText: "Gambar",
                                                labelText: "Gambar",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _gambar = value!;
                                                });
                                              },
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Gambar tidak boleh kosong!";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "Judul Buku",
                                                labelText: "Judul Buku",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _judul = value!;
                                                });
                                              },
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Judul tidak boleh kosong!";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RawAutocomplete(
                                              optionsBuilder: (TextEditingValue
                                                  textEditingValue) {
                                                if (textEditingValue.text ==
                                                    '') {
                                                  return const Iterable<
                                                      String>.empty();
                                                } else {
                                                  List<String> matches =
                                                      <String>[];
                                                  matches.addAll(list_kategori);

                                                  matches.retainWhere((s) {
                                                    return s
                                                        .toLowerCase()
                                                        .contains(
                                                            textEditingValue
                                                                .text
                                                                .toLowerCase());
                                                  });
                                                  return matches;
                                                }
                                              },
                                              onSelected: (String selection) {},
                                              fieldViewBuilder:
                                                  (BuildContext context,
                                                      TextEditingController
                                                          textEditingController,
                                                      FocusNode focusNode,
                                                      VoidCallback
                                                          onFieldSubmitted) {
                                                return TextFormField(
                                                  controller:
                                                      textEditingController,
                                                  focusNode: focusNode,
                                                  decoration: InputDecoration(
                                                    hintText: "Kategori",
                                                    labelText: "Kategori",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                  ),
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _kategori = value;
                                                    });
                                                  },
                                                  validator: (String? value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Kategori tidak boleh kosong!";
                                                    }
                                                    return null;
                                                  },
                                                );
                                              },
                                              optionsViewBuilder: (BuildContext
                                                      context,
                                                  void Function(String)
                                                      onSelected,
                                                  Iterable<String> options) {
                                                return Material(
                                                  child: SizedBox(
                                                    height: 200,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children:
                                                            options.map((opt) {
                                                          return InkWell(
                                                            onTap: () {
                                                              _kategori = opt;
                                                              onSelected(opt);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          60),
                                                              child: Card(
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child:
                                                                      Text(opt),
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
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "Penulis",
                                                labelText: "Penulis",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _penulis = value!;
                                                });
                                              },
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Penulis tidak boleh kosong!";
                                                }
                                                return null;
                                              },
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
                                              child: const Text('Submit',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  final response =
                                                      await request.postJson(
                                                          "https://readandbrew-c08-tk.pbp.cs.ui.ac.id/booklist/create-book-flutter/",
                                                          jsonEncode(<String,
                                                              String>{
                                                            "judul": _judul,
                                                            "kategori":
                                                                _kategori,
                                                            "penulis": _penulis,
                                                            "gambar": _gambar,
                                                            // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                                          }));
                                                  if (response['status'] ==
                                                      'success') {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          response['messages']),
                                                    ));
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BooklistPage("",
                                                                  "", "", "")),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          response['messages']),
                                                    ));
                                                  }
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
                    child: Text('Add Book',
                        style: TextStyle(color: Colors.white))),
              )
            : null);
  }
}
