import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';

class WorldStats extends StatelessWidget {
  final Map worldData;

  WorldStats(this.worldData);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2),
        children: <Widget>[
          WorldCard(
            Colors.blue[100],
            Colors.blue,
            'CONFIRMED',
            worldData['cases'].toString(),
          ),
          WorldCard(
            Colors.red[100],
            Colors.red,
            'ACTIVE',
            worldData['active'].toString(),
          ),
          WorldCard(
            Colors.green[100],
            Colors.green,
            'RECOVERED',
            worldData['recovered'].toString(),
          ),
          WorldCard(
            Colors.grey[400],
            Colors.grey[900],
            'DEATHS',
            worldData['deaths'].toString(),
          ),
        ],
      ),
    );
  }
}

class WorldCard extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String title;
  final String data;

  WorldCard(this.color, this.textColor, this.title, this.data);

  final display = createDisplay(
    length: 15,
    decimal: 0,
  );


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      margin: EdgeInsets.all(10),
      height: 80,
      width: width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style:
                  TextStyle(fontSize: 20, color: textColor, fontWeight: FontWeight.w700,)),
          Text(display(int.parse(data)),
              style:
                  TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.w600,)),
        ],
      ),
    );
  }
}
