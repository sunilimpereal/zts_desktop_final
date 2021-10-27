import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/widgets/ticket_history_table.dart';
import 'package:zts_counter_desktop/main.dart';

class TicketSummaryScreen extends StatefulWidget {
  const TicketSummaryScreen({Key? key}) : super(key: key);

  @override
  _TicketSummaryScreenState createState() => _TicketSummaryScreenState();
}

class _TicketSummaryScreenState extends State<TicketSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    log( "date"+ DateTime.now().toString());
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Ticket History'),
              ],
            ),
            TicketHistoryTable()
          ],
        ),
      ),
    );
  }
}
