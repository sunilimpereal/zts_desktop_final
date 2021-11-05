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

import 'package:zts_counter_desktop/utils/shared_pref.dart';

class Category {
  String name;
  List<TableRowDataPDF> dataList;
  Category({required this.name, required this.dataList});
}

class PdfApi {
  int total = 0;
  int length = 5;

  static Future<File> zooBill({
    required List<CategoryModel> listCategory,
    required String ticketNumber,
    required DateTime dateTime,
    required Uint8List image,
    required double total,
  }) async {
    final pdf = Document(title: "hello");
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );
    final qrcode = pw.MemoryImage(image);
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
        pageFormat: PdfPageFormat.roll80.copyWith(
          height: 400 + (printlines * 12),
          marginLeft: 0.3 * PdfPageFormat.cm,
          marginRight: 0.3 * PdfPageFormat.cm,
        ),
        build: (pw.Context context) => [
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  pw.Container(height: 15, child: pw.Image(elephantlogo)),
                  pw.SizedBox(width: 4),
                  pw.Container(
                    width: 100,
                    child: pw.Text('${sharedPrefs.organizationName}',
                        maxLines: 2, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                pw.SizedBox(height: 2),
                Pdftext(text: 'SAVE FOREST, SAVE WILDLIFE'),
                pw.SizedBox(height: 4),
                Pdftext(text: 'Ticket Number : ${ticketNumber}'),
                Pdftext(text: 'Time : ${DateFormat('dd/MM/yyyy kk:mm').format(time)}'),
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
                    pw.SizedBox(width: 8, height: 16),
                  ],
                ),
                // zooInvoice(people),
                pw.SizedBox(width: 8, height: 16),
                pw.Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  pw.Container(width: 70, child: pw.Image(qrcode)),
                ]),
                pw.SizedBox(width: 8, height: 16),
                Pdftext(text: 'THANK YOU VISIT AGAIN...'),
                Pdftext(text: 'LOVE AND PROTECT ANIMALS...'),
                pw.SizedBox(height: 3),
                pw.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      Pdftext(text: 'Powered By '),
                      pw.SizedBox(height: 3),
                      pw.Container(height: 24, child: pw.Image(logo)),
                    ])
                  ],
                ),
              ]),
            ]));

    return saveDocument(name: 'zooBill.pdf', pdf: pdf);
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

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Widget bill(List<CategoryModel> list) {
    final headers = ['', 'Per \nTicker', 'Qty', 'Total'];

    return Container();
  }

  static Widget lineItem(Category dataList) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: Pdftext(
            text: dataList.name, fontSize: 12, heightPadding: 2, fontWeight: FontWeight.bold),
      ),
      zooInvoice(dataList.dataList)
    ]);
  }

  static Widget zooInvoice(List<TableRowDataPDF> dataList) {
    final data = dataList.map((item) {
      return [item.name, item.perTicket, item.qty, item.total];
    }).toList();
    final headerList = ['         ', '   Per \nTicket', 'QTY', 'Total'];
    return pw.Column(children: [
      Table.fromTextArray(
        headers: headerList,
        data: data,
        headerPadding: const pw.EdgeInsets.symmetric(vertical: 8),

        border: const TableBorder(bottom: BorderSide(width: 0.3), top: BorderSide(width: 0.3)),
        headerStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              width: 0.5,
            ),
          ),
        ),
        cellStyle: const TextStyle(fontSize: 8),
        // headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 1,
        cellPadding: const pw.EdgeInsets.all(6),
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
        },
        headerAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
        },
      ),
      pw.SizedBox(height: 2),
    ]);
  }

  static buildText({
    required String title,
    required String value,
    MainAxisAlignment? alignment = MainAxisAlignment.spaceBetween,
    double width = double.infinity,
    double padding = 0,
    TextStyle? titleStyle,
    double? size = 4,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
        width: width,
        child: pw.Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: pw.Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              pw.Container(child: pw.Text("TOTAL :", style: const TextStyle(fontSize: 10))),
              pw.SizedBox(width: 4, height: 8),
              pw.Container(
                child: pw.Text(' Rs. $value',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              // pw.SizedBox(width: 8, height: 8),
            ],
          ),
        ));
  }

  static Future<File> billSummary(
      {required List<LineSumryItem> linesItems,
      required String userEmail,
      required DateTime dateTime}) async {
    final pdf = Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );
    final elephantlogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/elephantlogo.png')).buffer.asUint8List(),
    );
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.roll80.copyWith(
          height: 250 + (linesItems.length * 12.5),
          marginTop: 0.2 * PdfPageFormat.cm,
          marginLeft: 0.3 * PdfPageFormat.cm,
          marginRight: 0.3 * PdfPageFormat.cm,
        ),
        // pageFormat: const PdfPageFormat(
        //   72 * PdfPageFormat.mm,
        //   80 * PdfPageFormat.mm,
        //
        // ),
        build: (pw.Context context) => [
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  pw.Container(height: 20, child: pw.Image(elephantlogo)),
                  pw.SizedBox(width: 8),
                  pw.Container(
                    child: pw.Text('${sharedPrefs.organizationName}',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                pw.SizedBox(height: 3),
                Pdftext(
                    text: "Agent Daily Summary",
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    heightPadding: 2),
                Pdftext(text: 'User : $userEmail', fontSize: 8, heightPadding: 2),
                Pdftext(
                    text: "date : ${DateFormat('dd/MM/yyyy').format(dateTime)}",
                    fontSize: 8,
                    heightPadding: 2),
                pw.SizedBox(height: 6),
                // pw.Column(children: linesItems.map((e) => summarylineItem(e)).toList()),
                zooSummaryInvoice(linesItems
                    .map((e) => SummaryTableRowDataPDF(
                        name: '${e.subcategory} ${e.type}',
                        qty: e.count,
                        total: e.count * e.subcategoryPrice))
                    .toList()),
                pw.SizedBox(height: 3),
                pw.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      Pdftext(text: 'Powered By '),
                      pw.SizedBox(height: 3),
                      pw.Container(height: 24, child: pw.Image(logo)),
                    ])
                  ],
                ),
              ]),
            ]));

    return saveDocument(name: 'BillSummary.pdf', pdf: pdf);
  }

  static Widget summarylineItem(
    LineSumryItem dataList,
  ) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      // Pdftext(text:, fontSize: 4, heightPadding: 2),
      // zooSummaryInvoice(dataList )
    ]);
  }

  static Widget zooSummaryInvoice(List<SummaryTableRowDataPDF> dataList) {
    double billtotal = 0;
    final data = dataList.map((item) {
      billtotal = billtotal + item.total;
      return [item.name, item.qty, item.total];
    }).toList();
    final headerList = ['ZOO', ' Quantity', 'Amount'];
    return pw.Column(children: [
      Table.fromTextArray(
        headers: headerList,
        data: data,
        border: const TableBorder(bottom: BorderSide(width: 0.3), top: BorderSide(width: 0.3)),
        headerStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        cellStyle: const TextStyle(fontSize: 8),
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              width: 0.5,
            ),
          ),
        ),
        // headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 1,
        cellPadding: pw.EdgeInsets.all(2),
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.center,
          2: Alignment.centerRight,
        },
      ),
      pw.SizedBox(height: 2),
      buildText(
          title: 'ZOO Total',
          value: '$billtotal',
          size: 5,
          alignment: pw.MainAxisAlignment.spaceBetween,
          padding: 2),
    ]);
  }
}

class Pdftext extends pw.StatelessWidget {
  String text;
  double? widthPadding;
  double? heightPadding;
  FontWeight? fontWeight;
  double? fontSize;
  Pdftext({
    required this.text,
    this.widthPadding = 0,
    this.fontWeight = FontWeight.normal,
    this.heightPadding = 0,
    this.fontSize = 10,
  });

  @override
  Widget build(pw.Context context) {
    return pw.Container(
        child: pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: heightPadding!, horizontal: widthPadding!),
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(text,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
                ])));
  }
}

class TableRowDataPDF {
  final String name;
  final String perTicket;
  final int qty;
  final double total;
  final bool even;
  const TableRowDataPDF({
    required this.name,
    required this.perTicket,
    required this.qty,
    required this.total,
    required this.even,
  });
}

class SummaryTableRowDataPDF {
  final String name;
  final int qty;
  double total;
  SummaryTableRowDataPDF({
    required this.name,
    required this.qty,
    required this.total,
  });
}

//  on pressesd

// onPressed: () async {
//           final pdfFile =
//               await PdfApi.zooBill();
//           PdfApi.openFile(pdfFile);
//         }
