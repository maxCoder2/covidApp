import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dynamic_theme/dynamic_theme.dart';

import '../screens/searchScreen.dart';
import '../screens/countryScreen.dart';
import '../screens/homePage.dart';


class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {'page': HomePage(), 'title': 'Home'},
    {'page': CountryScreen(), 'title': 'By Country'}
  ];

  var _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  List countryData;

  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=deaths');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[ _selectedPageIndex == 0 ? 
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.lightbulb_outline
                  : Icons.highlight,
            ),
            onPressed: () {
              DynamicTheme.of(context).setBrightness(
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light);
            },
          ) : IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchScreen(countryData));
            },
          )
        ],
        title: Text(_pages[_selectedPageIndex]['title']),
        
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(onTap: _selectPage,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor: Colors.white,
      unselectedItemColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor: Colors.white,
      selectedItemColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,
      items: [BottomNavigationBarItem(icon: Icon(Icons.world))],),
    );
  }
}
