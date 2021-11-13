import 'dart:developer';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';

class TicketReport extends StatefulWidget {
  const TicketReport({Key? key}) : super(key: key);

  @override
  _TicketReportState createState() => _TicketReportState();
}

class _TicketReportState extends State<TicketReport> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      children: [heading(), data()],
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

    return StreamBuilder<List<GeneratedTickets>>(
        stream: TicketProvider.of(context).ticketHistoryStream,
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.73,
            child: !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: getTicketRows(snapshot.data ?? []),
                    ),
                  ),
          );
        });
  }

  List<Widget> getTicketRows(List<GeneratedTickets> list) {
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
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: e.isScanned ? Colors.green : Colors.red),
              ),
              cell(flex: 4, text: '${e.number}', even: a.isEven),
              cell(
                  flex: 4,
                  text: DateFormat().add_Hm().addPattern(' ').add_yMEd().format(e.issuedTs),
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
