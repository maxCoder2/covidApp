import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Notify with ChangeNotifier {
  bool pieChart = false;

void changePieChart() {
    pieChart = !pieChart;
    notifyListeners();
  }

  IconData get getGraphIcon {
    if (pieChart)
    {
      return MdiIcons.chartBellCurveCumulative;
    }
    else
    {
      return MdiIcons.chartPie;
    }
  }
}