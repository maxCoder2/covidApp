import 'dart:io';

import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';

import 'countryStatsScreen.dart';

class SearchScreen extends SearchDelegate {
  final List countryList;

  final display = createDisplay(
    length: 15,
    decimal: 0,
  );

  SearchScreen(this.countryList);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = query.isEmpty
        ? countryList
        : countryList
            .where((element) =>
                element['country'].toString().toLowerCase().startsWith(query))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CountryStatsScreen(
                  suggestionList[index]['country'],
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 130,
            child: Row(
              children: <Widget>[
                Container(
                  width: 150,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(suggestionList[index]['country'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Image.network(
                        suggestionList[index]['countryInfo']['flag'],
                        height: 50,
                        width: 80.901,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Confirmed: ${display(suggestionList[index]['cases'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Active: ${display(suggestionList[index]['active'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Recovered: ${display(suggestionList[index]['recovered'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Deaths: ${display(suggestionList[index]['deaths'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[100]
                                    : Colors.grey[900],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? countryList
        : countryList
            .where((element) =>
                element['country'].toString().toLowerCase().startsWith(query))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 130,
            child: Row(
              children: <Widget>[
                Container(
                  width: 150,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(suggestionList[index]['country'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Image.network(
                        suggestionList[index]['countryInfo']['flag'],
                        height: 50,
                        width: 80.901,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Confirmed: ${display(suggestionList[index]['cases'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Active: ${display(suggestionList[index]['active'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Recovered: ${display(suggestionList[index]['recovered'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Deaths: ${display(suggestionList[index]['deaths'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[100]
                                    : Colors.grey[900],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
