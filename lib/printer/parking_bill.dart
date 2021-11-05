import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/printer/bill_pdf.dart';

import 'package:zts_counter_desktop/utils/shared_pref.dart';

import 'dart:io';

class ParkingPdf {
  static Future<File> parkingBill({
    required List<CategoryModel> listCategory,
    required String ticketNumber,
    required DateTime dateTime,
    required Uint8List qrImage,
    required double total,
  }) async {
    final pdf = Document(title: "hello");
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );
    final qrcode = pw.MemoryImage(qrImage);
    final elephantlogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/elephantlogo.png')).buffer.asUint8List(),
    );

    DateTime time = DateTime.now();
    List<Category> lineList = getselectedLineItem(listCategory);
    // final Uint8List fontData = File('assets/fonts/NotoSerifKannada-Medium.ttf').readAsBytesSync();
    // Font kannada = Font.ttf(fontData.buffer.asByteData());
    int printlines = 0;
    for (Category cat in lineList) {
      printlines = printlines + 1;
      printlines = printlines + cat.dataList.length;
    }
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.roll57.copyWith(
          height: 190 + (printlines * 12),
          marginLeft: 0.3 * PdfPageFormat.cm,
          marginRight: 0.3 * PdfPageFormat.cm,
        ),
        build: (pw.Context context) => [
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pw.Container(height: 15, child: pw.Image(elephantlogo)),
                  pw.SizedBox(width: 4),
                  pw.Container(
                    width: 100,
                    child: pw.Text('${sharedPrefs.organizationName}',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                pw.SizedBox(height: 2),
                Pdftext(text: 'SAVE FOREST, SAVE WILDLIFE'),
                pw.SizedBox(height: 4),
                Pdftext(text: 'Ticket Number : ${ticketNumber}'),
                Pdftext(text: 'Time : ${DateFormat('yyyy/MM/dd kk:mm').format(time)}'),
                pw.SizedBox(height: 4),
                // tableleHeader(),

                pw.Column(children: lineList.map((e) => lineItem(e)).toList()),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    pw.Container(child: pw.Text("TOTAL :", style: const TextStyle(fontSize: 12))),
                    pw.SizedBox(width: 4, height: 8),
                    pw.Container(
                      child: pw.Text(' Rs. $total',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    pw.SizedBox(width: 8, height: 8),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  pw.Container(width: 60, child: pw.Image(qrcode)),
                ]),

                pw.SizedBox(height: 8),
                Pdftext(text: 'THANK YOU VISIT AGAIN...'),
                Pdftext(text: 'LOVE AND PROTECT ANIMALS...'),
                pw.SizedBox(height: 3),
                pw.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Pdftext(text: 'Powered By '),
                    pw.Container(height: 8, child: pw.Image(logo)),
                  ],
                ),
              ]),
            ]));

    return saveDocument(name: 'zooBill.pdf', pdf: pdf);
  }

  static Widget lineItem(Category dataList) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: Pdftext(text: 'Parking', fontSize: 12, heightPadding: 2, fontWeight: FontWeight.bold),
      ),
      zooInvoice(dataList.dataList)
    ]);
  }

  static Widget zooInvoice(List<TableRowDataPDF> dataList) {
    final data = dataList.map((item) {
      return [item.name, item.perTicket, item.qty, item.total];
    }).toList();
    final headerList = ['       ', 'per Ticket', ' QTY', 'Total'];
    return pw.Column(children: [
      Table.fromTextArray(
        headers: headerList,
        data: data,
        border: const TableBorder(bottom: BorderSide(width: 0.3), top: BorderSide(width: 0.3)),
        headerStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
        cellStyle: const TextStyle(fontSize: 10),
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              width: 0.5,
            ),
          ),
        ),
        cellHeight: 1,
        cellPadding: const pw.EdgeInsets.all(2),
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
        },
      ),
      pw.SizedBox(height: 2),
    ]);
  }

  static List<Category> getselectedLineItem(List<CategoryModel> list) {
    List<Category> widgetList = [];
    bool even = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i].categoryQyantity != 0) {
        List<TableRowDataPDF> widgetListtemp = [];
        for (int si = 0; si < list[i].subcategories.length; si++) {
          if (list[i].subcategories[si].quantity != 0) {
            even = !even;
            widgetListtemp.add(TableRowDataPDF(
              even: !even,
              name: list[i].subcategories[si].name + ' ' + list[i].subcategories[si].type,
              perTicket: list[i].subcategories[si].price.toString(),
              qty: list[i].subcategories[si].quantity,
              total: list[i].subcategories[si].quantity * list[i].subcategories[si].price,
            ));
          }
        }

        widgetList.add(Category(name: list[i].name, dataList: widgetListtemp));
      }
    }
    return widgetList;
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }
}
