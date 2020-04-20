import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import '../providers/notify.dart';

class MainStatsScreen extends StatefulWidget {
  @override
  _MainStatsScreenState createState() => _MainStatsScreenState();
}

class _MainStatsScreenState extends State<MainStatsScreen> {
  List countryData;

  Future<void> fetchCountryDeathPieData() async {
    http.Response response = await http
        .get('https://corona.lmao.ninja/v2/countries?sort=todayDeaths');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  List countryCaseData;

  Future<void> fetchCountryCasesPieData() async {
    http.Response response = await http
        .get('https://corona.lmao.ninja/v2/countries?sort=todayCases');
    setState(() {
      countryCaseData = json.decode(response.body);
    });
  }

  Map worldData;

  fetchWorldData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  Map casesTimeData;

  fetchCasesTimeData() async {
    http.Response response = await http
        .get('https://corona.lmao.ninja/v2/historical/all?lastdays=all');
    setState(() {
      casesTimeData = json.decode(response.body);
    });
  }

  var first = true;

  List<charts.Series<TodayPieInfo, String>> _todayDeathPieData =
      List<charts.Series<TodayPieInfo, String>>();
  List<charts.Series<TodayPieInfo, String>> _todayCasePieData =
      List<charts.Series<TodayPieInfo, String>>();

  List<charts.Series<Point, int>> _casesTimeLineData =
      List<charts.Series<Point, int>>();

  Future<void> _generateData() async {
    _generateTodayDeathPieInfo();
    _generateTodayCasePieInfo();
    _generatePoints();
  }

  _generateTodayCasePieInfo() {
    List<TodayPieInfo> data = List<TodayPieInfo>();
    for (int i = 0; i < 6; i++) {
      var sumCases = 0;
      sumCases += countryCaseData[i]['todayCases'];
      if (i == 5 && countryCaseData[6]['todayCases'] > 0) {
        data.add(TodayPieInfo(
          'Other',
          worldData['todayCases'] - sumCases,
          colors[i],
        ));
      } else if (countryCaseData[i]['todayCases'] == 0) {
        break;
      } else {
        data.add(
          TodayPieInfo(
            countryCaseData[i]['country'],
            countryCaseData[i]['todayCases'],
            colors[i],
          ),
        );
      }
    }

    _todayCasePieData.add(
      charts.Series(
        data: data,
        domainFn: (TodayPieInfo country, _) => country.name,
        measureFn: (TodayPieInfo country, _) => country.value,
        colorFn: (TodayPieInfo country, _) =>
            charts.ColorUtil.fromDartColor(country.color),
        id: 'TodayCases',
        labelAccessorFn: (TodayPieInfo row, _) => '${row.value}',
      ),
    );
  }

  _generateTodayDeathPieInfo() {
    List<TodayPieInfo> data = List<TodayPieInfo>();
    for (int i = 0; i < 6; i++) {
      var sumDeaths = 0;

      sumDeaths += countryData[i]['todayDeaths'];
      if (i == 5 && countryData[6]['todayDeaths'] > 0) {
        data.add(TodayPieInfo(
          'Other',
          worldData['todayDeaths'] - sumDeaths,
          colors[i],
        ));
      } else if (countryData[i]['todayDeaths'] == 0) {
        break;
      } else {
        data.add(
          TodayPieInfo(
            countryData[i]['country'],
            countryData[i]['todayDeaths'],
            colors[i],
          ),
        );
      }
    }

    _todayDeathPieData.add(
      charts.Series(
        data: data,
        domainFn: (TodayPieInfo country, _) => country.name,
        measureFn: (TodayPieInfo country, _) => country.value,
        colorFn: (TodayPieInfo country, _) =>
            charts.ColorUtil.fromDartColor(country.color),
        id: 'TodayDeaths',
        labelAccessorFn: (TodayPieInfo row, _) => '${row.value}',
      ),
    );
  }

  DateTime _formatDate(String time) {
    String theDate = DateFormat('MM/dd/yyyy').parse(time).toString();
    theDate = theDate.substring(2, theDate.length - 4);
    return DateTime.parse('20' + theDate);
  }

  int _daysSinceJan22(DateTime dateTime) {
    final jan22 = DateTime(2020, 1, 22);
    return dateTime.difference(jan22).inDays;
  }

  _generatePoints() {
    List<Point> casesTime = List<Point>();
    (casesTimeData['cases'] as Map).forEach(
      (key, value) => {
        casesTime.add(
          Point(value, _formatDate(key)),
        ),
      },
    );
    List<Point> deathsTime = List<Point>();
    (casesTimeData['deaths'] as Map).forEach(
      (key, value) => {
        deathsTime.add(
          Point(value, _formatDate(key)),
        ),
      },
    );
    List<Point> recoveredTime = List<Point>();
    (casesTimeData['recovered'] as Map).forEach(
      (key, value) => {
        recoveredTime.add(
          Point(value, _formatDate(key)),
        ),
      },
    );

    _casesTimeLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(
          Color(0xff2196f3),
        ),
        id: 'Cases',
        data: casesTime,
        measureFn: (Point point, _) => point.value,
        domainFn: (Point point, _) => _daysSinceJan22(point.time),
      ),
    );
    _casesTimeLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(
          Theme.of(context).brightness == Brightness.light
              ? Color(0xff000000)
              : Color(0xfff44336),
        ),
        id: 'Deaths',
        data: deathsTime,
        measureFn: (Point point, _) => point.value,
        domainFn: (Point point, _) => _daysSinceJan22(point.time),
      ),
    );
    _casesTimeLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(
          Color(0xff4caf50),
        ),
        id: 'Recovered',
        data: recoveredTime,
        measureFn: (Point point, _) => point.value,
        domainFn: (Point point, _) => _daysSinceJan22(point.time),
      ),
    );
  }

  @override
  void initState() {
    fetchCountryDeathPieData().then((response) =>
        fetchCountryCasesPieData().then((response) => _generateData()));
    fetchWorldData();
    fetchCasesTimeData();
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

  Widget _buildPieChartSection(
      String title, List<charts.Series<TodayPieInfo, String>> data) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(5),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              title,
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
                data,
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
                      fontFamily: 'Lato',
                      fontSize: 13,
                    ),
                  ),
                ],
                defaultRenderer: charts.ArcRendererConfig(
                  arcWidth: (MediaQuery.of(context).size.width * 0.3).round(),
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                      labelPadding: 0,
                      labelPosition: charts.ArcLabelPosition.auto,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var axis = Theme.of(context).brightness == Brightness.light
        ? charts.NumericAxisSpec()
        : charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
                labelStyle:
                    charts.TextStyleSpec(color: charts.MaterialPalette.white)),
          );

    return countryData == null ||
            worldData == null ||
            _todayCasePieData == null ||
            _todayDeathPieData == null ||
            _casesTimeLineData == null
        ? Center(child: CircularProgressIndicator())
        : Provider.of<Notify>(context).pieChart
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    _buildPieChartSection(
                        'Today\'s Deaths', _todayDeathPieData),
                    _buildPieChartSection('Today\'s Cases', _todayCasePieData),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Overall',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                  backgroundColor: Colors.blue, maxRadius: 6),
                              SizedBox(width: 6),
                              Text(
                                'Confirmed',
                                style:
                                    TextStyle(fontFamily: 'Lato', fontSize: 13),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                  backgroundColor: Colors.green, maxRadius: 6),
                              SizedBox(width: 6),
                              Text(
                                'Recovered',
                                style:
                                    TextStyle(fontFamily: 'Lato', fontSize: 13),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.red,
                                  maxRadius: 6),
                              SizedBox(width: 6),
                              Text(
                                'Deaths',
                                style:
                                    TextStyle(fontFamily: 'Lato', fontSize: 13),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: charts.LineChart(
                          _casesTimeLineData,
                          defaultRenderer: charts.LineRendererConfig(
                              includeArea: false, stacked: false),
                          animate: true,
                          animationDuration: Duration(seconds: 1),
                          primaryMeasureAxis: axis,
                          behaviors: [
                            charts.ChartTitle(
                              'Days Since Jan 22, 2020',
                              behaviorPosition: charts.BehaviorPosition.bottom,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middleDrawArea,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
  }
}

class TodayPieInfo {
  String name;
  int value;
  Color color;

  TodayPieInfo(this.name, this.value, this.color);
}

class Point {
  int value;
  DateTime time;

  Point(this.value, this.time);

  @override
  String toString() {
    return '$time, $value';
  }
}
