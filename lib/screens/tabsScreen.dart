import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../screens/searchScreen.dart';
import '../screens/countryScreen.dart';
import '../screens/homePage.dart';
import '../screens/mainStatsScreen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {'page': HomePage(), 'title': 'World'},
    {'page': CountryScreen(), 'title': 'By Country'},
    {'page': MainStatsScreen(_pieChart), 'title': 'Stats'}
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
  void initState() {
    fetchCountryData();
    super.initState();
  }

  static bool _pieChart = true;

  IconData _getGraphIcon(bool boolean) {
    if (boolean)
    {
      return MdiIcons.chartBellCurveCumulative;
    }
    else
    {
      return MdiIcons.chartPie;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).primaryColor
          : Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Theme.of(context).primaryColor,
        actions: <Widget>[
          _selectedPageIndex == 0
              ? IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.light
                        ? Icons.lightbulb_outline
                        : Icons.highlight,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                  onPressed: () {
                    DynamicTheme.of(context).setBrightness(
                        Theme.of(context).brightness == Brightness.light
                            ? Brightness.dark
                            : Brightness.light);
                  },
                )
              : _selectedPageIndex == 1
                  ? IconButton(
                      icon: Icon(Icons.search),
                      onPressed: countryData == null
                          ? null
                          : () {
                              showSearch(
                                  context: context,
                                  delegate: SearchScreen(countryData));
                            },
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    )
                  : IconButton(
                      icon: Icon(
                        _getGraphIcon(_pieChart),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _pieChart = !_pieChart;
                        });
                      },
                    ),
        ],
        title: Text(
          _pages[_selectedPageIndex]['title'],
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).primaryColor
                : Colors.white,
          ),
        ),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor
            : Colors.white,
        unselectedItemColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[500]
            : Theme.of(context).primaryColorLight,
        selectedItemColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.globeModel),
            title: Text('World'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.flagOutline),
            title: Text('Countries'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.chartBar),
            title: Text('Stats'),
          ),
        ],
      ),
    );
  }
}
