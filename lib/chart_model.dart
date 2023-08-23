import 'package:cloud_firestore/cloud_firestore.dart';

class ChartModel {
  Timestamp dateTime;
  int turbidity;
  int tds;

  ChartModel(
      {required this.dateTime, required this.tds, required this.turbidity});
}
