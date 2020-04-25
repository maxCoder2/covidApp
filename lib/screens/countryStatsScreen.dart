import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import './mainStatsScreen.dart';

class CountryStatsScreen extends StatefulWidget {
  final String countryName;

  CountryStatsScreen(this.countryName);
  @override
  _CountryStatsScreenState createState() => _CountryStatsScreenState();
}

class _CountryStatsScreenState extends State<CountryStatsScreen> {
  Map countryData;

  List<charts.Series<Point, DateTime>> _casesTimeLineData =
      List<charts.Series<Point, DateTime>>();

  Future<void> fetchCountryData() async {
    http.Response response = await http.get(
        'https://corona.lmao.ninja/v2/historical/${widget.countryName}?lastdays=all');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchCountryData().then((response) => _generatePoints());
    super.initState();
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
    countryData['timeline']['cases'].forEach(
      (key, value) => {
        casesTime.add(
          Point(value, _formatDate(key)),
        ),
      },
    );
    List<Point> deathsTime = List<Point>();
    countryData['timeline']['deaths'].forEach(
      (key, value) => {
        deathsTime.add(
          Point(value, _formatDate(key)),
        ),
      },
    );
    List<Point> recoveredTime = List<Point>();
    countryData['timeline']['recovered'].forEach(
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
        domainFn: (Point point, _) => point.time,
      ),
    );
    _casesTimeLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(
          Color(0xfff44336),
        ),
        id: 'Deaths',
        data: deathsTime,
        measureFn: (Point point, _) => point.value,
        domainFn: (Point point, _) => point.time,
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
        domainFn: (Point point, _) => point.time,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.countryName} Stats'),
        ),
        body: countryData == null
            ? Center(
                child: CircularProgressIndicator(),
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
                                  backgroundColor: Colors.red, maxRadius: 6),
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
                        child: charts.TimeSeriesChart(
                          _casesTimeLineData,
                          defaultRenderer: charts.LineRendererConfig(
                              includeArea: false, stacked: false),
                          animate: true,
                          animationDuration: Duration(seconds: 1),
                          domainAxis: charts.DateTimeAxisSpec(
                            renderSpec: charts.GridlineRendererSpec(
                              axisLineStyle: charts.LineStyleSpec(
                                  color: Theme.of(context).brightness == Brightness.light ? charts.Color.black : charts.Color.white),
                              labelStyle: charts.TextStyleSpec(
                                  color: Theme.of(context).brightness == Brightness.light ? charts.Color.black : charts.Color.white),
                              lineStyle: charts.LineStyleSpec(
                                  color: Theme.of(context).brightness == Brightness.light ? charts.Color.black : charts.Color.white),
                            ),
                          ),
                          primaryMeasureAxis: charts.NumericAxisSpec(
                            renderSpec: charts.GridlineRendererSpec(
                              axisLineStyle: charts.LineStyleSpec(
                                  color: Theme.of(context).brightness == Brightness.light ? charts.Color.black : charts.Color.white),
                              labelStyle: charts.TextStyleSpec(
                                  color: Theme.of(context).brightness == Brightness.light ? charts.Color.black : charts.Color.white),
                              lineStyle: charts.LineStyleSpec(
                                  color: Theme.of(context).brightness == Brightness.light ? charts.Color.black : charts.Color.white),
                            ),
                          ),
                          // behaviors: [
                          //   charts.ChartTitle(
                          //     '',
                          //     behaviorPosition: charts.BehaviorPosition.bottom,
                          //     titleOutsideJustification:
                          //         charts.OutsideJustification.middleDrawArea,
                          //   ),
                          // ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
