import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:read_and_brew/models/requestbuku.dart';
import 'package:read_and_brew/screens/bookrequest_all_detail.dart';
import 'package:read_and_brew/screens/bookrequest_individual.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';

class RequestBukuAllPage extends StatefulWidget {
  const RequestBukuAllPage({Key? key}) : super(key: key);

  @override
  _RequestBukuAllPageState createState() => _RequestBukuAllPageState();
}

class _RequestBukuAllPageState extends State<RequestBukuAllPage> {
  String filterStatus = "All"; // Default filter status
  String sortBy = "Judul"; // Default sorting option

  Future<List<RequestBuku>> fetchProduct(String status, String sortBy) async {
    var url = Uri.parse(
        'https://readandbrew-c08-tk.pbp.cs.ui.ac.id/bookrequest/get_books');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<RequestBuku> listProduct = [];
    for (var d in data) {
      if (d != null) {
        RequestBuku requestBuku = RequestBuku.fromJson(d);
        if (status == "All" || requestBuku.fields.status == status) {
          listProduct.add(requestBuku);
        }
      }
    }

    // Sort based on selected option
    if (sortBy == "Judul") {
      listProduct.sort((a, b) =>
          a.fields.judul.toLowerCase().compareTo(b.fields.judul.toLowerCase()));
    } else if (sortBy == "Like") {
      listProduct.sort((a, b) => b.fields.like.compareTo(a.fields.like));
    } else if (sortBy == "Status") {
      listProduct.sort((a, b) => a.fields.status.compareTo(b.fields.status));
    }

    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Color(0xFF377C35),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( // Use Row to align the dropdowns horizontally
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          menuMaxHeight: 300,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: "Status",
                            hintText: "Status",
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
                          value: filterStatus,
                          onChanged: (String? newValue) {
                            setState(() {
                              filterStatus = newValue ?? "All";
                            });
                          },
                          items: <String>['All', 'Approved', 'Waiting For Approval']
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Add some space between the dropdowns
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          menuMaxHeight: 300,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: "Sort By",
                            hintText: "Sort By",
                            prefixIcon: Icon(Icons.sort),
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
                          value: sortBy,
                          onChanged: (String? newValue) {
                            setState(() {
                              sortBy = newValue ?? "Judul";
                            });
                          },
                          items: <String>['Judul', 'Like', 'Status']
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchProduct(filterStatus, sortBy),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum ada request buku.",
                          style: TextStyle(
                              color: Color(0xFF377C35), fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: (1 / 1.5),
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                requestBuku: snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: snapshot.data![index].fields.status !=
                                        "Approved"
                                    ? Color.fromARGB(255, 118, 124, 53)
                                    : Color(0xFF377C35),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 1.0,
                          color: snapshot.data![index].fields.status !=
                                  "Approved"
                              ? Color.fromARGB(255, 235, 227, 162)
                              : Color.fromARGB(255, 235, 255, 235),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data![index].fields.status,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 27, 68, 26),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Image.network(
                                    snapshot.data![index].fields.gambar,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Icon(
                                        Icons.error,
                                        size: 100.0,
                                        color: Colors.red,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data![index].fields.judul,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        snapshot.data![index].fields.penulis,
                                        style: TextStyle(fontSize: 16.0),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.thumb_up,
                                            color: Color.fromARGB(255, 1, 97, 16),
                                            size: 18.0,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            snapshot.data![index]
                                                .fields
                                                .like
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
