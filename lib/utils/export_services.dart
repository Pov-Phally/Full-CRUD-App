// lib/utils/export_service.dart
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:full_crud_app/models/products.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

// PDF exporter
Future<void> exportToPDF(List<Product> products) async {
  if (products.isEmpty) {
    if (kDebugMode) {
      print('Error: No products available to export.');
    }
    return;
  }

  try {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();

    // Add title
    page.graphics.drawString(
      'Product List',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(0, 0, 500, 30),
    );

    // Initialize grid
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);
    grid.headers.add(1);

    // Populate header cells
    grid.headers[0].cells[0].value = 'Name';
    grid.headers[0].cells[1].value = 'Price';
    grid.headers[0].cells[2].value = 'Stock';

    // Populate data rows
    for (final product in products) {
      final row = grid.rows.add();
      row.cells[0].value = product.name;
      row.cells[1].value = product.price.toString();
      row.cells[2].value = product.stock.toString();
    }

    // Draw grid
    final Size pageSize = page.getClientSize();
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 40, pageSize.width, pageSize.height - 40),
    );

    // Save document
    final List<int> bytes = await document.save();
    document.dispose();

    // Write to file
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/products.pdf');
    await file.writeAsBytes(bytes, flush: true);

    // Open file
    await OpenFile.open(file.path);
    if (kDebugMode) {
      print('PDF file exported successfully.');
    }
  } catch (e, st) {
    if (kDebugMode) {
      print('Error exporting to PDF: $e\n$st');
    }
  }
}

// CSV exporter
Future<void> exportToCSV(List<Product> products) async {
  try {
    final rows = <List<dynamic>>[
      ['Name', 'Price', 'Stock'],
      for (var p in products) [p.name, p.price, p.stock],
    ];

    final csvData = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/products.csv');
    await file.writeAsString(csvData, flush: true);
    await OpenFile.open(file.path);

    if (kDebugMode) {
      print('CSV file exported successfully.');
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}