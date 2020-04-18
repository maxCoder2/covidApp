import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:charts_flutter/flutter.dart' as charts;

class MainStatsScreen extends StatefulWidget {
  bool _pieChart;

  MainStatsScreen(this._pieChart);

  @override
  _MainStatsScreenState createState() => _MainStatsScreenState();
}

class _MainStatsScreenState extends State<MainStatsScreen> {
  List countryData;

  Future<void> fetchCountryData() async {
    http.Response response = await http
        .get('https://corona.lmao.ninja/v2/countries?sort=todayDeaths');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Map worldData;

  fetchWorldData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  var first = true;

  List<charts.Series<CountryInfo, String>> _seriesPieData =
      List<charts.Series<CountryInfo, String>>();

  Future<void> _generateData() async {
    List<CountryInfo> data = List<CountryInfo>();
    for (int i = 0; i < 6; i++) {
      var sumDeaths = 0;
      sumDeaths += countryData[i]['todayDeaths'];

      if (i == 5 && countryData[6]['todayDeaths'] > 0) {
        data.add(CountryInfo(
          'Other',
          worldData['todayDeaths'] - sumDeaths,
          colors[i],
        ));
      } else if (countryData[i]['todayDeaths'] == 0) {
        break;
      } else {
        data.add(
          CountryInfo(
            countryData[i]['country'],
            countryData[i]['todayDeaths'],
            colors[i],
          ),
        );
      }
    }

    _seriesPieData.add(
      charts.Series(
        data: data,
        domainFn: (CountryInfo country, _) => country.name,
        measureFn: (CountryInfo country, _) => country.value,
        colorFn: (CountryInfo country, _) =>
            charts.ColorUtil.fromDartColor(country.color),
        id: 'Country',
        labelAccessorFn: (CountryInfo row, _) => '${row.value}',
      ),
    );
  }

  @override
  void initState() {
    fetchCountryData().then((response) => _generateData());
    fetchWorldData();
    super.initState();
  }

  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.blue,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    return countryData == null || worldData == null
        ? Center(child: CircularProgressIndicator())
        : widget._pieChart ? Container(
            padding: EdgeInsets.all(5),
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Today\'s Deaths',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: charts.PieChart(
                        _seriesPieData,
                        animate: true,
                        animationDuration: Duration(seconds: 1),
                        behaviors: [
                          charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
                            cellPadding: EdgeInsets.only(right: 4, bottom: 4),
                            entryTextStyle: charts.TextStyleSpec(
                              // color: charts.MaterialPalette.purple.shadeDefault,
                              fontFamily: 'Lato',
                              fontSize: 13,
                            ),
                          ),
                        ],
                        defaultRenderer: charts.ArcRendererConfig(
                          arcWidth:
                              (MediaQuery.of(context).size.width * 0.3).round(),
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.auto,
                                )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) : Container();
  }
}

class CountryInfo {
  String name;
  int value;
  Color color;

  CountryInfo(this.name, this.value, this.color);
}
