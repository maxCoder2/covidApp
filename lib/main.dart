import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:provider/provider.dart';

import './screens/tabsScreen.dart';
import './providers/notify.dart';


void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Notify(),),
      ],
          child: DynamicTheme(
        data: (brightness) {
          return ThemeData(
            brightness: brightness == Brightness.light
                ? Brightness.light
                : Brightness.dark,
            scaffoldBackgroundColor: brightness == Brightness.dark
                ? Colors.blueGrey[900]
                : Colors.white,
            primaryColor: Color.fromRGBO(0, 26, 51, 1),
            fontFamily: 'Lato',
            // textTheme: ThemeData.dark().textTheme.copyWith(
            //       //main text theme
            //       title: TextStyle(
            //         //header
            //         fontFamily: 'Montserrat',
            //         fontWeight: FontWeight.bold,
            //         fontSize: 28,
            //         color: Color.fromRGBO(0, 26, 51, 1),
            //       ),
            //       body1: TextStyle(
            //         //body
            //         fontFamily: 'OpenSans',
            //         fontSize: 18,
            //         color: Color.fromRGBO(0, 26, 51, 1),
            //       ),
            //       body2: TextStyle(
            //           //subheader
            //           fontFamily: 'OpenSans',
            //           fontSize: 21,
            //           color: Color.fromRGBO(0, 26, 51, 1),
            //           fontWeight: FontWeight.w600),
            //       display4: TextStyle(
            //         //disabled subheader text (for a button)
            //         fontFamily: 'OpenSans',
            //         fontSize: 21,
            //         color: Colors.grey[800],
            //       ),
            //     ),
          );
        },
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: TabsScreen(),
          );
        },
      ),
    );
  }
}
