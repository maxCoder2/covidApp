import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:number_display/number_display.dart';
import './countryStatsScreen.dart';

class CountryScreen extends StatefulWidget {
  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
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

  final display = createDisplay(
    length: 15,
    decimal: 0,
  );

  @override
  Widget build(BuildContext context) {
    return countryData == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CountryStatsScreen(
                  countryData[index]['country'],
                ),
              ),
            );
          },
                child: Card(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 130,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(countryData[index]['country'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                  )),
                              Image.network(
                                countryData[index]['countryInfo']['flag'],
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
                                  'Confirmed: ${display(countryData[index]['cases'])}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blue,
                                      fontSize: MediaQuery.of(context).size.width * 0.041),
                                ),
                                Text(
                                  'Active: ${display(countryData[index]['active'])}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red,
                                    fontSize: MediaQuery.of(context).size.width * 0.041,
                                  ),
                                ),
                                Text(
                                  'Recovered: ${display(countryData[index]['recovered'])}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green,
                                    fontSize: MediaQuery.of(context).size.width * 0.041,
                                  ),
                                ),
                                Text(
                                  'Deaths: ${display(countryData[index]['deaths'])}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[100]
                                        : Colors.grey[900],
                                    fontSize: MediaQuery.of(context).size.width * 0.041,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: countryData == null ? 0 : countryData.length,
          );
  }
}
