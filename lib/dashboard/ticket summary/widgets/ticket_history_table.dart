import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';

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
      height: MediaQuery.of(context).size.height * 0.8,
      color: Colors.red,
      child: Column(
        children: [
          heading(),
          data(),
        ],
      ),
    );
  }

  Widget heading() {
    return Container(
      height: 30,
      child: Row(
        children: [
          cell(flex: 6, text: 'Name'),
          cell(flex: 3, text: 'Quantity'),
          cell(flex: 3, text: 'Total'),
        ],
      ),
    );
  }

  Widget data() {
    return StreamBuilder<List<LineSumryItem>>(
        stream: TicketProvider.of(context).lineItemSummary,
        builder: (context, snapshot) {
          log("data ${snapshot.data}");
          return Column(
            children: getTicketRows(snapshot.data ?? []),
          );
        });
  }

  Widget cell({required int flex, required String text}) {
    return Container(
      child: Flexible(
        flex: flex,
        child: Container(
          color: Colors.green,
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getTicketRows(List<LineSumryItem> list) {
    List<Widget> widgetList = list.map((e) {
      return Container(
        height: 30,
        child: Row(
          children: [
            cell(flex: 6, text: '${e.subcategory} ${e.type}'),
            cell(flex: 3, text: '${e.count}'),
            cell(flex: 3, text: '${e.lineitemPrice * e.count}'),
          ],
        ),
      );
    }).toList();

    return widgetList;
  }
}
