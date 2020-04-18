import 'package:flutter/material.dart';

class MostAffected extends StatelessWidget {
  final List countryData;

  MostAffected(this.countryData);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: <Widget>[
                  Image.network(
                    countryData[index]['countryInfo']['flag'],
                    height: 30,
                    width: 48.541,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    countryData[index]['country'],
                    style: TextStyle(
                        color: Theme.of(context).textTheme.title.color, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Deaths: ${countryData[index]['deaths']}',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ));
        },
        itemCount: 5,
      ),
    );
  }
}
