import 'package:flutter/material.dart';
import 'package:line_charts/chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

class ChartDisplay extends StatefulWidget {
  const ChartDisplay({super.key});

  @override
  State<ChartDisplay> createState() => _ChartDisplayState();
}

class _ChartDisplayState extends State<ChartDisplay> {
  List<ChartModel> chartData = <ChartModel>[];

  Future<void> getDataFromFirestore() async {
    var snapshotsValue =
        await FirebaseFirestore.instance.collection('LiveData').get();
    List<ChartModel> list = snapshotsValue.docs
        .map((e) => ChartModel(
            dateTime: e.data()['DateTime'],
            turbidity: e.data()['Turbidity'],
            tds: e.data()['TDS']))
        .toList();
    setState(() {
      chartData = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getDataFromFirestore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Data display'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: double.infinity,
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<ChartModel, String>>[
            LineSeries<ChartModel, String>(
                dataSource: chartData,
                xValueMapper: (ChartModel _model, _) =>
                    _model.turbidity.toString(),
                yValueMapper: (ChartModel _model, _) => _model.tds)
          ],
        ),
      ),
    );
  }
}
