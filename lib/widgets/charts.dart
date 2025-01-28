import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../analytics/warehouse_analytics.dart';
import '../models/warehouse.dart'; // Adjust the path as necessary

Widget buildCharts(Warehouse warehouse) {
  final analytics = WarehouseAnalytics(warehouse);
  
  return Column(
    children: [
      const Text('Product Distribution', 
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      SizedBox(
        height: 200,
        child: SfCircularChart(
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: analytics.getProductDistribution(),
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ),
      const SizedBox(height: 20),
      const Text('Expiry Distribution',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      SizedBox(
        height: 200,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: analytics.getExpiryDistribution(),
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ),
    ],
  );
}