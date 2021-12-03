import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:printing/printing.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_repository.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/widgets/date_picker.dart';
import 'package:zts_counter_desktop/printer/bill_pdf.dart';

import '../../../main.dart';

class TicketHistoryTable extends StatefulWidget {
  const TicketHistoryTable({Key? key}) : super(key: key);

  @override
  _TicketHistoryTableState createState() => _TicketHistoryTableState();
}

class _TicketHistoryTableState extends State<TicketHistoryTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ticket Summary',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              ZTSDatePicker(
                onSelectionChanged: (value) {
                  TicketProvider.of(context).getLineItemSumry(value);
                },
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Material(
              elevation: 5,
              shadowColor: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        heading(),
                        data(),
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Total :',
                                style: TextStyle(fontSize: 24, color: Colors.green),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              StreamBuilder<List<LineSumryItem>>(
                                  stream: TicketProvider.of(context).lineItemSummary,
                                  builder: (context, snapshot) {
                                    return Text(
                                      '${total(snapshot.data ?? [])}',
                                      style: TextStyle(fontSize: 24, color: Colors.green),
                                    );
                                  })
                            ],
                          ),
                          StreamBuilder<List<LineSumryItem>>(
                              stream: TicketProvider.of(context).lineItemSummary,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                    onPressed: () async {
                                      final pdfFile = await PdfApi.billSummary(
                                          dateTime: TicketProvider.of(context).selectedDate,
                                          linesItems: snapshot.data ?? [],
                                          userEmail: sharedPref.userEmail);
                                      final pdf = pdfFile.readAsBytes();
                                      List<Printer> printerList = await Printing.listPrinters();
                                      sharedPref.getPrinter.length > 2
                                          ? await Printing.directPrintPdf(
                                              printer: printerList.firstWhere((element) =>
                                                  element.name == sharedPref.getPrinter),
                                              onLayout: (_) => pdf)
                                          : await Printing.layoutPdf(onLayout: (_) => pdf);
                                      //PdfApi.openFile(pdfFile);
                                    },
                                    child: const Text('Print Summary'));
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double total(List<LineSumryItem> line) {
    double total = 0;
    for (LineSumryItem item in line) {
      total = total + item.lineitemPrice;
    }
    return total;
  }

  Widget heading() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        height: 30,
        child: Row(
          children: [
            cell(flex: 6, text: 'Name'),
            cell(flex: 3, text: 'Quantity'),
            cell(flex: 3, text: 'Total'),
          ],
        ),
      ),
    );
  }

  Widget data() {
    return StreamBuilder<List<LineSumryItem>>(
        stream: TicketProvider.of(context).lineItemSummary,
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: getTicketRows(snapshot.data ?? []),
                    ),
                  ),
          );
        });
  }

  Widget cell({required int flex, required String text, bool? even}) {
    var withOpacity = Colors.green[50]?.withOpacity(0.5);
    return Container(
      child: Flexible(
        flex: flex,
        child: Container(
          color: even ?? false ? withOpacity : Colors.white,
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 4,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getTicketRows(List<LineSumryItem> list) {
    int a = 1;
    List<Widget> widgetList = list.map((e) {
      a++;
      double total = e.lineitemPrice * e.count;
      return Container(
        height: 30,
        child: Row(
          children: [
            cell(flex: 6, text: '${e.subcategory} ${e.type}', even: a.isEven),
            cell(flex: 3, text: '${e.count}', even: a.isEven),
            cell(flex: 3, text: '${e.lineitemPrice}', even: a.isEven),
          ],
        ),
      );
    }).toList();
    return widgetList;
  }
}
