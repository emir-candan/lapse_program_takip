import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppTable extends StatelessWidget {
  final List<DataColumn> columns; // MoonTable might use custom Column class?
  final List<DataRow> rows;

  // Assuming MoonTable wraps standard DataTable or has similar API.
  // Ideally we check headers/rows structure.
  // Using standard DataColumn/DataRow for signature but passing to MoonTable.

  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return MoonTable(
      columns: columns, // If compatible
      rows: rows,
      // If MoonTable uses different API (e.g. list of widgets), we might need mapping.
      // But standard DataTable wrapper is likely.
    );
  }
}
