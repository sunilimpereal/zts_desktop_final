import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class Person {
  String type;
  double amount;
  double qty;
  Person({
    required this.type,
    required this.amount,
    required this.qty,
  });
}

class PdfApi {
  static Future<File> zooBill() async {
    final pdf = Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );
    final qrcode = pw.MemoryImage(
      (await rootBundle.load('assets/images/qrCode.png')).buffer.asUint8List(),
    );
    final elephantlogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/elephantlogo.png'))
          .buffer
          .asUint8List(),
    );
    DateTime time = DateTime.now();

    List<Person> people = [
      Person(type: 'Non Indian Adult ', amount: 1000, qty: 10),
      Person(type: 'Indian Adult ', amount: 1000, qty: 10),
    ];
    final Uint8List fontData =
        File('assets/fonts/NotoSerifKannada-Medium.ttf').readAsBytesSync();
    Font kannada = Font.ttf(fontData.buffer.asByteData());
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat(
          40 * PdfPageFormat.mm,
          80 * PdfPageFormat.mm,
          marginTop: 0.2 * PdfPageFormat.cm,
          marginLeft: 0.1 * PdfPageFormat.cm,
          marginRight: 0.1 * PdfPageFormat.cm,
        ),
        build: (pw.Context context) => [
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pw.Container(height: 15, child: pw.Image(elephantlogo)),
                  pw.Container(
                    width: 100,
                    child: pw.Text('Zoo Name',
                        style: TextStyle( fontSize: 5)),
                  ),
                ],
              ),
              pw.Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 2),
                    Pdftext(text: 'SAVE FOREST, SAVE WILDLIFE'),
                    pw.SizedBox(height: 4),
                    Pdftext(text: 'Ticket Number : MYS53171024541'),
                    Pdftext(
                        text:
                            'Time : ${DateFormat('yyyy/MM/dd kk:mm').format(time)}'),
                    pw.SizedBox(height: 3),
                    Pdftext(
                        text: 'Safari + Zoo',
                        fontWeight: FontWeight.bold,
                        fontSize: 5),
                    zooInvoice(people),
                    pw.Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          pw.Container(height: 35, child: pw.Image(qrcode)),
                        ]),
                    pw.SizedBox(height: 3),
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
                  ])
            ]));

    return saveDocument(name: 'zooBill.pdf', pdf: pdf);
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

  static Widget zooInvoice(List<Person> people) {
    final headers = ['', 'Per Ticker', 'Qty', 'Total'];
    double billtotal = 0;
    final data = people.map((item) {
      final total = item.amount * item.qty;
      billtotal = billtotal + total;
      return [item.type, item.amount, item.qty, total];
    }).toList();

    return pw.Column(children: [
      Table.fromTextArray(
        headers: headers,
        data: data,
        border: TableBorder(
            bottom: BorderSide(width: 0.3), top: BorderSide(width: 0.3)),
        headerStyle: TextStyle(fontSize: 4, fontWeight: FontWeight.bold),
        cellStyle: TextStyle(fontSize: 4),
        // headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 1,
        cellPadding: pw.EdgeInsets.all(2),
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
        },
      ),
      pw.SizedBox(height: 2),
      buildText(title: 'TOTAL', value: '$billtotal', size: 5),
      pw.Padding(
        padding: EdgeInsets.all(2),
        child: pw.Container(
          height: 0.2,
          color: PdfColors.black,
        ),
      ),
    ]);
  }

  static buildText({
    required String title,
    required String value,
    MainAxisAlignment? alignment = MainAxisAlignment.spaceBetween,
    double width = double.infinity,
    TextStyle? titleStyle,
    double? size = 4,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: alignment!,
        children: [
           Pdftext(text: title, fontSize: size),
          Pdftext(text: value, fontSize: size),
        ],
      ),
    );
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
    this.fontSize = 4,
  });

  @override
  Widget build(pw.Context context) {
    return pw.Container(
        child: pw.Padding(
            padding: pw.EdgeInsets.symmetric(
                vertical: heightPadding!, horizontal: widthPadding!),
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(text,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: fontSize, fontWeight: fontWeight)),
                ])));
  }
}



//  on pressesd

// onPressed: () async {
//           final pdfFile =
//               await PdfApi.zooBill();
//           PdfApi.openFile(pdfFile);
//         }
