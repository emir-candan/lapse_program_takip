import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    // Reverting to standard DataTable since MoonTable API mismatches 
    // or requires complex mapping. Safe wrapper is good.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: rows,
      ),
    );
  }
}
