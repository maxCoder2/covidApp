import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/faqsScreen.dart';

class InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => FAQScreen()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'FAQS',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Icon(
                      Platform.isIOS
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_forward,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launch(
                    'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/donate');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'DONATE',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Icon(
                      Platform.isIOS
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_forward,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launch(
                    'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'MORE INFORMATION',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Icon(
                      Platform.isIOS
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_forward,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
