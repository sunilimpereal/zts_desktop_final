import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/main.dart';

import 'package:zts_counter_desktop/utils/shared_pref.dart';

class Category {
  String name;
  List<TableRowDataPDF> dataList;
  Category({required this.name, required this.dataList});
}

class PdfApi {
  int total = 0;
  int length = 5;
  static Uint8List fontData = File('assets/fonts/NotoSerifKannada-Medium.ttf').readAsBytesSync();
  static Font kannada = Font.ttf(fontData.buffer.asByteData());
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
        (await rootBundle.load('assets/images/elephantlogo.png')).buffer.asUint8List());
    final zootitle =
        pw.MemoryImage((await rootBundle.load('assets/images/zootitle.png')).buffer.asUint8List());
    final karanji =
        pw.MemoryImage((await rootBundle.load('assets/images/karanji.png')).buffer.asUint8List());

    DateTime time = DateTime.now();
    List<Category> lineList = getselectedLineItem(listCategory);

    int printlines = 0;

    bool showNumber = false;
    bool showTicketValidity = false;
    for (Category cat in lineList) {
      if (cat.name.toLowerCase().contains('student')) {
        printlines = printlines + 2;
      }
      if (sharedPrefs.getVehicleNumber.length > 1 && cat.name.toLowerCase().contains("parking")) {
        printlines = printlines + 1;
        showNumber = true;
      }
      if (cat.name.toLowerCase().contains("karanji entrance") ||
          cat.name.toLowerCase().contains("parking")) {
        showTicketValidity = true;
      }
      printlines = printlines + cat.dataList.length;
    }
    pdf.addPage(
      MultiPage(
        orientation: pw.PageOrientation.natural,
        pageFormat: PdfPageFormat.roll80.copyWith(
          height: 340 +
              (printlines * 30) +
              (listCategory.length * 70) +
              (showTicketValidity ? 20 : 0) +
              (showNumber ? 20 : 0),
          marginLeft: 6 * PdfPageFormat.mm,
          marginRight: 6 * PdfPageFormat.mm,
        ),
        build: (pw.Context context) => [
          pw.Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sharedPrefs.userEmail == 'karanji1@myszoo.com'
                  ? pw.Container(height: 33, child: pw.Image(karanji))
                  : pw.Container(height: 35, child: pw.Image(zootitle)),
              pw.SizedBox(width: 12),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            pw.SizedBox(height: 2),
            Pdftext(text: 'SAVE FOREST, SAVE WILDLIFE'),
            pw.SizedBox(height: 4),
            Pdftext(text: 'Ticket Number : $ticketNumber'),
            pw.SizedBox(height: 4),
            Pdftext(text: 'Time : ${DateFormat('dd/MM/yyyy kk:mm').format(time)}'),
            pw.SizedBox(height: 4),
            showNumber
                ? pw.Column(children: [
                    Pdftext(text: 'Vehicle Number : ${sharedPref.getVehicleNumber}'),
                    pw.SizedBox(height: 4),
                  ])
                : pw.SizedBox(),

            // tableleHeader(),

            pw.Column(children: lineList.map((e) => lineItem(e)).toList()),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(child: pw.Text('TOTAL :', style: const TextStyle(fontSize: 14))),
                pw.SizedBox(width: 4, height: 8),
                pw.Container(
                  child: pw.Text(' ₹ $total',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, font: kannada)),
                ),
                pw.SizedBox(width: 8, height: 8),
              ],
            ),
            // zooInvoice(people),
            pw.SizedBox(width: 8, height: 8),
            pw.Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              pw.Container(width: 200, height: 80, child: pw.Image(qrcode, fit: pw.BoxFit.contain)),
            ]),
            pw.SizedBox(width: 8, height: 8),
            showTicketValidity
                ? pw.Column(children: [
                    Pdftext(text: 'Valid for 4 Hours,Overstay will be charged.'),
                    pw.SizedBox(width: 8, height: 8),
                  ])
                : pw.SizedBox(),
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
        ],
      ),
    );
    return saveDocument(name: 'bin.acc', pdf: pdf);
    
    

    
    
    
    
    
    
    
    

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
        padding: const pw.EdgeInsets.only(top: 6, bottom: 4),
        child: Pdftext(
            text: dataList.name, fontSize: 14, heightPadding: 2, fontWeight: FontWeight.bold),
      ),
      zooInvoice(dataList.dataList)
    ]);
  }

  static Widget zooInvoice(List<TableRowDataPDF> dataList) {
    final data = dataList.map((item) {
      return [item.name, item.perTicket, item.qty, item.total.round()];
    }).toList();
    final headerList = ['      ', '   Per \nTicket', 'QTY', 'Total'];
    return pw.Column(children: [
      Table.fromTextArray(
        headers: headerList,
        data: data,
        border: const TableBorder(bottom: BorderSide(width: 0.3), top: BorderSide(width: 0.3)),
        headerStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              width: 0.5,
            ),
          ),
        ),

        headerPadding: pw.EdgeInsets.symmetric(vertical: 0, horizontal: 6.5),
        cellPadding: pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 5),
        cellStyle: TextStyle(fontSize: 12),
        // headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 1,

        columnWidths: {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
          2: FlexColumnWidth(3),
        },
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
    final zootitle =
        pw.MemoryImage((await rootBundle.load('assets/images/zootitle.png')).buffer.asUint8List());
    final karanji =
        pw.MemoryImage((await rootBundle.load('assets/images/karanji.png')).buffer.asUint8List());

    double getLength() {
      double length = 0;
      for (LineSumryItem lineItem in linesItems) {
        if ('${lineItem.subcategory} ${lineItem.type}'.length > 15) {
          length = length + 32;
        } else {
          length = length + 25;
        }
      }
      return length;
    }

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.roll80.copyWith(
          height: 300 + 30 + 20 + getLength(),
          marginTop: 2 * PdfPageFormat.mm,
          marginLeft: 6 * PdfPageFormat.mm,
          marginRight: 6 * PdfPageFormat.mm,
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
                  sharedPrefs.userEmail == 'karanji1@myszoo.com'
                      ? pw.Container(height: 35, child: pw.Image(karanji))
                      : pw.Container(height: 35, child: pw.Image(zootitle)),
                  pw.SizedBox(width: 8),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.SizedBox(height: 3),
                    Pdftext(
                        text: "Agent Daily Summary",
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        heightPadding: 2),
                    Pdftext(text: 'User : $userEmail', fontSize: 12, heightPadding: 4),
                    Pdftext(
                        text: "Summary Date : ${DateFormat('dd/MM/yyyy').format(dateTime)}",
                        fontSize: 12,
                        heightPadding: 4),
                    Pdftext(
                        text:
                            "Print Date : ${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}",
                        fontSize: 12,
                        heightPadding: 4),
                    pw.SizedBox(height: 6),
                    // pw.Column(children: linesItems.map((e) => summarylineItem(e)).toList()),
                    zooSummaryInvoice(linesItems
                        .map((e) => SummaryTableRowDataPDF(
                            name: '${e.subcategory} ${e.type}',
                            qty: e.count,
                            total: e.count * e.subcategoryPrice))
                        .toList()),
                    pw.SizedBox(height: 8),
                    pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 8),
                        child: pw.Column(children: [
                          pw.Container(
                              width: 200,
                              height: 35,
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(width: 0.5, color: PdfColors.black)),
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Row(children: [
                                pw.Text('Agent signature :', style: pw.TextStyle(fontSize: 10))
                              ])),
                          pw.Container(
                              width: 200,
                              height: 35,
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(width: 0.5, color: PdfColors.black)),
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Row(children: [
                                pw.Text('Finance signature :', style: pw.TextStyle(fontSize: 10))
                              ])),
                        ])),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                          Pdftext(text: 'Powered By '),
                          pw.SizedBox(height: 3),
                          pw.Container(height: 32, child: pw.Image(logo)),
                        ])
                      ],
                    ),
                  ]),
            ]));

    return saveDocument(name: 'bin.acc', pdf: pdf);
  }

  static Widget zooSummaryInvoice(List<SummaryTableRowDataPDF> dataList) {
    double billtotal = 0;
    final data = dataList.map((item) {
      billtotal = billtotal + item.total;
      return [item.name, item.qty, item.total.round()];
    }).toList();
    final headerList = ['Item', ' Quantity', 'Total'];
    return pw.Column(children: [
      Table.fromTextArray(
        headers: headerList,
        data: data,
        border: const TableBorder(bottom: BorderSide(width: 0.3), top: BorderSide(width: 0.3)),
        headerStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        cellStyle: const TextStyle(fontSize: 12),
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              width: 0.5,
            ),
          ),
        ),
        // headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 1,

        columnWidths: {
          0: FlexColumnWidth(5),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(3),
        },
        cellPadding: pw.EdgeInsets.symmetric(vertical: 4),
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.center,
          2: Alignment.center,
        },
      ),
      pw.SizedBox(height: 6),
      pw.Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(child: pw.Text('TOTAL :', style: const TextStyle(fontSize: 14))),
          pw.SizedBox(width: 4, height: 8),
          pw.Container(
            child: pw.Text(' ₹ $billtotal',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, font: kannada)),
          ),
          pw.SizedBox(width: 8, height: 16),
        ],
      ),
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
    this.fontSize = 12,
  });

  @override
  Widget build(pw.Context context) {
    return pw.Container(
        child: pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: heightPadding!, horizontal: widthPadding!),
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(text,
                      textAlign: pw.TextAlign.left,
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
