import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/regionalButton.dart';
import '../widgets/infoCard.dart';
import '../widgets/mostAffected.dart';
import '../widgets/worldStats.dart';
import '../dataSource.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String quote = '';

  DateTime lastFetchTime;

  String _getRandomQuote() {
    return DataSource.quotes[Random().nextInt(DataSource.quotes.length)];
  }

  Future<void> _refresh() async {
    fetchCountryData();
    fetchCountryData();
    lastFetchTime = DateTime.now();
  }

  Map worldData;

  fetchWorldData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
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
    quote = _getRandomQuote();
    fetchWorldData();
    fetchCountryData();
    lastFetchTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refresh,
              child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                height: 50,
                child: Text(
                  'Last updated: ' +
                      DateFormat.yMMMMEEEEd().format(lastFetchTime) +
                      ' ' +
                      DateFormat.jms().format(lastFetchTime),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              worldData == null
                  ? Center(child: CircularProgressIndicator())
                  : WorldStats(worldData),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Most Affected Countries',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
              ),
              SizedBox(height: 10),
              countryData == null ? Container() : MostAffected(countryData),
              InfoCard(),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                'WE ARE TOGETHER IN THE FIGHT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              )),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
  }
}
