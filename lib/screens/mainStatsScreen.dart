import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:charts_flutter/flutter.dart' as charts;

class MainStatsScreen extends StatefulWidget {
  @override
  _MainStatsScreenState createState() => _MainStatsScreenState();
}

class _MainStatsScreenState extends State<MainStatsScreen> {
  List countryData;

  fetchCountryData() async {
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

  @override
  void initState() {
    fetchCountryData();
    fetchWorldData();
    super.initState();
  }

  var first = true;

  @override
  void didChangeDependencies() {
    if (first) {
      _seriesPieData = List<charts.Series<CountryInfo, String>>();
      _generateData();
      first = false;
    }
    super.didChangeDependencies();
  }

  List<charts.Series<CountryInfo, String>> _seriesPieData;

  void _generateData() {
    List data;
    for (int i = 0; i < 8; i++) {
      var sumDeaths = 0;
      sumDeaths += countryData[i]['todayDeaths'];

      data.add(
        CountryInfo(
          countryData[i]['country'],
          (countryData[i]['todayDeaths'] / worldData['todayDeaths']) * 100,
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0),
        ),
      );
      if (countryData[i]['todayDeaths'] == 0) {
        break;
      }
      if (i == 7 && countryData[8]['todayDeaths'] > 0) {
        data.add(CountryInfo(
          'Other',
          ((worldData['todayDeaths'] - sumDeaths) / worldData['todayDeaths']) *
              100,
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0),
        ));
      }
    }

    _seriesPieData.add(
      charts.Series(
        data: data,
        domainFn: (CountryInfo country, _) => country.name,
        measureFn: (CountryInfo country, _) => country.percentage,
        colorFn: (CountryInfo country, _) =>
            charts.ColorUtil.fromDartColor(country.color),
        id: 'Country',
        labelAccessorFn: (CountryInfo row, _) => '${row.percentage}',
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return countryData == null || worldData == null
        ? CircularProgressIndicator()
        : Padding(
            padding: EdgeInsets.all(10),
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
                              color: charts.MaterialPalette.purple.shadeDefault,
                              fontFamily: 'Lato',
                              fontSize: 13,
                            ),
                          ),
                        ],
                        defaultRenderer: charts.ArcRendererConfig(
                          arcWidth:
                              (MediaQuery.of(context).size.width * 0.5).round(),
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class CountryInfo {
  String name;
  double percentage;
  Color color;

  CountryInfo(this.name, this.percentage, this.color);
}
