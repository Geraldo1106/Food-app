import 'package:efood_multivendor_restaurant/controller/report_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatefulWidget {
  final ReportController reportController;
  const LineChartWidget({Key? key, required this.reportController}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<LineChartWidget> {
  List<Color> gradientColors = [
    const Color(0xFFF4BE37),
    const Color(0x80FFFFFF),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfCartesianChart(
          // Initialize category axis
            primaryXAxis: CategoryAxis(),
            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                // Bind data source
                dataSource: widget.reportController.label!.map((e) {
                  int index = widget.reportController.label!.indexOf(e);
                  return SalesData(e, widget.reportController.earning![index]);
                }).toList(),
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales,
                onPointTap: (value){
                  print('=========$value');
                }
              )
            ],
        )
    );
    // return AspectRatio(
    //   aspectRatio: 1.95,
    //   child: DecoratedBox(
    //     decoration: const BoxDecoration(
    //       borderRadius: BorderRadius.all(
    //         Radius.circular(18),
    //       ),
    //       //color: Color(0xff232d37),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.only(
    //         right: 18,
    //         left: 12,
    //         top: 24,
    //         bottom: 12,
    //       ),
    //       child: GetBuilder<ReportController>(
    //           builder: (reportController) {
    //             return LineChart(mainData(reportController.earningChartList, reportController.maxValue));
    //           }
    //       ),
    //     ),
    //   ),
    // );
  }

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     color: Color(0xff68737d),
  //     fontWeight: FontWeight.normal,
  //     fontSize: 12,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 0:
  //       text = const Text('Jan', style: style);
  //       break;
  //     case 1:
  //       text = const Text('Feb', style: style);
  //       break;
  //     case 2:
  //       text = const Text('Mar', style: style);
  //       break;
  //     case 3:
  //       text = const Text('Apr', style: style);
  //       break;
  //     case 4:
  //       text = const Text('May', style: style);
  //       break;
  //     case 5:
  //       text = const Text('Jun', style: style);
  //       break;
  //     case 6:
  //       text = const Text('Jul', style: style);
  //       break;
  //     case 7:
  //       text = const Text('Aug', style: style);
  //       break;
  //     case 8:
  //       text = const Text('Sep', style: style);
  //       break;
  //     case 9:
  //       text = const Text('Oct', style: style);
  //       break;
  //     case 10:
  //       text = const Text('Nov', style: style);
  //       break;
  //     case 11:
  //       text = const Text('Dec', style: style);
  //       break;
  //     default:
  //       text = const Text('', style: style);
  //       break;
  //   }
  //
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: text,
  //   );
  // }
  //
  // LineChartData mainData(List<FlSpot>? spots, double maxValue) {
  //   return LineChartData(
  //     gridData: FlGridData(
  //       show: true,
  //       drawVerticalLine: true,
  //       drawHorizontalLine: true,
  //       horizontalInterval: 1,
  //       verticalInterval: 1,
  //       getDrawingHorizontalLine: (value) {
  //         return const FlLine(
  //           color: Color(0xff37434d),
  //           strokeWidth: 0,
  //         );
  //       },
  //       getDrawingVerticalLine: (value) {
  //         return const FlLine(
  //           color: Color(0xff37434d),
  //           strokeWidth: 0,
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           interval: 1,
  //
  //           getTitlesWidget: bottomTitleWidgets,
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           interval: maxValue/5 <=0? 1 : maxValue/5,
  //           reservedSize: 50,
  //         ),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: true,
  //     ),
  //     minX: 0,
  //     maxX: 11,
  //     minY: 0,
  //     maxY: maxValue,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: spots!,
  //         isCurved: false,
  //         gradient: LinearGradient(
  //           colors: gradientColors,
  //         ),
  //         barWidth: 1,
  //         show: true,
  //         isStrokeCapRound: true,
  //         dotData: const FlDotData(
  //           show: true,
  //
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: gradientColors
  //                 .map((color) => color.withOpacity(0.15))
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}