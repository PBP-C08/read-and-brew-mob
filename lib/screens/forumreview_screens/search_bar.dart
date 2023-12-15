import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/forumreview_screens/their_reviews.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
            appBar: AppBar(
              title: const Text("Search Book"),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final selected = await showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(items),
                    );
                    if (selected != null && selected != false) {
                      // Handle the selected item
                      print('Selected: $selected');
                    }
                  },
                ),
              ],
            ),
            body: filteredItems.isEmpty ?
              TheirReviews() :
              ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredItems[index]),
                  );
                },
              ) 
          );
  }
}

List<String> items = List.generate(100, (index) => 'Item $index');
List<String> filteredItems = [];

class CustomSearchDelegate extends SearchDelegate {
  final List<String> items;

  CustomSearchDelegate(this.items);
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, false);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filteredItems = items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredItems[index]),
          onTap: () {
            close(context, filteredItems[index]);
          },
        );
      },
    );
  }
}

