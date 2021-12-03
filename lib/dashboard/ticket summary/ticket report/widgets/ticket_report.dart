import 'dart:developer';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket_report_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/ticket%20report/widgets/download_report.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/ticket%20report/widgets/duration_dropdown.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/ticket%20report/widgets/reload_button.dart';

import '../../../../utils/methods.dart';
import '../../widgets/date_picker.dart';

class TicketReport extends StatefulWidget {
  const TicketReport({Key? key}) : super(key: key);

  @override
  _TicketReportState createState() => _TicketReportState();
}

class _TicketReportState extends State<TicketReport> {
  bool isHour = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Ticket Report',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
              Row(children: [
                getRole() == 'admin' || getRole() == 'manager'
                    ? DownloadTicketReport()
                    : Container(),
                ZTSReloadButton(
                  isHour: isHour,
                ),
                ZTSDurationDropdown(
                  onChanged: (value) {
                    setState(() {
                      log("asd" + isHour.toString());
                      isHour = value;
                    });
                  },
                )
              ])
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
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
                        StreamBuilder<bool>(
                            stream: TicketProvider.of(context).ticketReportLoadingStream,
                            builder: (context, snapshot) {
                              log(snapshot.data.toString());
                              if (snapshot.hasData) {
                                if (!snapshot.data!) {
                                  return data();
                                } else {
                                  return Container(
                                      height: MediaQuery.of(context).size.height * 0.73,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Text("Loading Report...")
                                          ],
                                        ),
                                      ));
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget heading() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        height: 30,
        child: Row(
          children: [
            cell(flex: 1, text: 'Status'),
            cell(flex: 4, text: 'Name'),
            cell(flex: 4, text: 'Issued Time'),
            cell(flex: 3, text: 'Price'),
          ],
        ),
      ),
    );
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
              const SizedBox(
                width: 4,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  Widget data() {
    final win = appWindow;
    log("scale ${win.scaleFactor.toString()}");

    return StreamBuilder<List<TicketReportItem>>(
        stream: TicketProvider.of(context).ticketReportStream,
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.73,
            child: snapshot.hasData
                ? snapshot.data!.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: getTicketRows(snapshot.data ?? []),
                        ),
                      )
                    : Center(
                        child: Text(
                          'No tickets generated ${TicketProvider.of(context).ticketReportisHour ? "in last one hour" : "today"}',
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                : const Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        });
  }

  List<Widget> getTicketRows(List<TicketReportItem> list) {
    int a = 1;
    List<Widget> widgetList = list.map((e) {
      a++;
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 35,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.035,
                height: 30,
                color: a.isEven ? Colors.green[50]?.withOpacity(0.5) : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: e.qrCode.isScanned ? Colors.green : Colors.red,
                        ),
                        child: Center(
                            child: Icon(
                          e.qrCode.isScanned ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 15,
                        ))),
                  ],
                ),
              ),
              cell(flex: 4, text: '${e.number}', even: a.isEven),
              cell(
                  flex: 4,
                  text: DateFormat()
                      .add_Hm()
                      .addPattern(' ')
                      .addPattern("dd/MM/yyy")
                      .format(e.issuedTs),
                  even: a.isEven),
              cell(flex: 3, text: '  ${e.price}', even: a.isEven),
            ],
          ),
        ),
      );
    }).toList();
    return widgetList;
  }
}
