import 'package:covid19tracker/dataSource.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView.builder(
          itemCount: DataSource.faqs.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                DataSource.faqs[index]['question'], 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    DataSource.faqs[index]['answer'],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
