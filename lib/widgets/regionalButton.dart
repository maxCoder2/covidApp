import 'package:flutter/material.dart';

import '../screens/countryScreen.dart';

class RegionalButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CountryScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.title.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'By Country',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Color.fromRGBO(0, 26, 51, 1),
            ),
          ),
        ),
      ),
    );
  }
}
