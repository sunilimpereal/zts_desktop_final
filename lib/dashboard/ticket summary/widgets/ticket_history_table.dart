import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:printing/printing.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket_report_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_repository.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/widgets/date_picker.dart';
import 'package:zts_counter_desktop/printer/bill_pdf.dart';
import 'package:zts_counter_desktop/utils/methods.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

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
                  TicketProvider.of(context).getTicketReport(showonlyHour: false, selcDate: value);
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
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    List<LineSumryItem> parkingFineItem = [];
                                    double getTotal(List<TicketReportItem> ticketReportList) {
                                      double totalFine = 0;
                                      for (TicketReportItem item in ticketReportList) {
                                        log("item : " + item.fine.toString());
                                        if (item.fine > 0) {
                                          totalFine = totalFine + item.fine;
                                        }
                                      }
                                      return totalFine;
                                    }

                                    List<TicketReportItem> ticketReportList =
                                        await TicketProvider.of(context).getTicketReport(
                                            showonlyHour: false,
                                            selcDate: TicketProvider.of(context).selectedDate);

                                    ticketReportList = ticketReportList
                                        .where((element) => element.fine != 0)
                                        .toList();
                                    List<TicketReportItem> completedList = [];
                                    for (TicketReportItem fineitem in ticketReportList) {
                                      TicketReportItem selecteditem = fineitem;
                                      List<TicketReportItem> selecteditemList = [];
                                      if (!parkingFineItem.map((e) => e.subcategory).toList().contains(
                                          '${selecteditem.lineitems[0].subcategoryName} ${selecteditem.lineitems[0].type}')) {
                                        for (TicketReportItem loopfineitem in ticketReportList) {
                                          if ('${loopfineitem.lineitems[0].subcategoryName} ${loopfineitem.lineitems[0].subcategoryName}' ==
                                              '${selecteditem.lineitems[0].subcategoryName} ${selecteditem.lineitems[0].subcategoryName}') {
                                            selecteditemList.add(loopfineitem);
                                          }
                                        }
                                      }

                                     selecteditemList.isNotEmpty? parkingFineItem.add(LineSumryItem(
                                          type: '',
                                          subcategory:
                                              '${selecteditem.lineitems[0].subcategoryName} ${selecteditem.lineitems[0].type}',
                                          subcategoryPrice: getTotal(selecteditemList),
                                          category: '',
                                          count: selecteditemList.length,
                                          lineitemPrice: getTotal(selecteditemList))):null;
                                    }
                                    final pdfFile = await PdfApi.parkingsummary(
                                        dateTime: TicketProvider.of(context).selectedDate,
                                        linesItems: parkingFineItem,
                                        userEmail: sharedPref.userEmail);
                                    final pdf = pdfFile.readAsBytes();
                                    List<Printer> printerList = await Printing.listPrinters();
                                    sharedPref.getPrinter.length > 2
                                        ? await Printing.directPrintPdf(
                                            printer: printerList.firstWhere(
                                                (element) => element.name == sharedPref.getPrinter),
                                            onLayout: (_) => pdf)
                                        : await Printing.layoutPdf(onLayout: (_) => pdf);
                                  },
                                  child: Text("Parking Add. Charges")),
                              SizedBox(
                                width: 5,
                              ),
                              StreamBuilder<List<LineSumryItem>>(
                                  stream: TicketProvider.of(context).lineItemSummary,
                                  builder: (context, snapshot) {
                                    return ElevatedButton(
                                        onPressed: () async {
                                          double getTotal(List<TicketReportItem> ticketReportList) {
                                            double totalFine = 0;
                                            for (TicketReportItem item in ticketReportList) {
                                              log("item : " + item.fine.toString());
                                              if (item.fine > 0) {
                                                totalFine = totalFine + item.fine;
                                              }
                                            }
                                            return totalFine;
                                          }

                                          List<TicketReportItem> ticketReportList =
                                              await TicketProvider.of(context).getTicketReport(
                                                  showonlyHour: false,
                                                  selcDate:
                                                      TicketProvider.of(context).selectedDate);
                                          ticketReportList = ticketReportList
                                              .where((element) => element.fine != 0)
                                              .toList();

                                          LineSumryItem lineSumryItem = LineSumryItem(
                                              type: "",
                                              subcategory: "Parking Additional Hours",
                                              subcategoryPrice: getTotal(ticketReportList),
                                              category: "",
                                              count: ticketReportList.length,
                                              lineitemPrice: getTotal(ticketReportList));
                                          List<LineSumryItem> lineSummaryItems =
                                              snapshot.data ?? [];
                                          if (getTotal(ticketReportList) > 0 &&
                                              getRole() == 'admin') {
                                            log("added");
                                            lineSummaryItems.add(lineSumryItem);
                                          } else {}
                                          final pdfFile = await PdfApi.billSummary(
                                              dateTime: TicketProvider.of(context).selectedDate,
                                              linesItems: lineSummaryItems,
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
