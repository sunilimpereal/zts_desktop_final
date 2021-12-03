import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/ticket%20report/widgets/ticket_report.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/widgets/ticket_history_table.dart';

class TicketSummaryScreen extends StatefulWidget {
  const TicketSummaryScreen({Key? key}) : super(key: key);

  @override
  _TicketSummaryScreenState createState() => _TicketSummaryScreenState();
}

class _TicketSummaryScreenState extends State<TicketSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TicketHistoryTable(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            const TicketReport()
          ],
        ),
      ),
    );
  }
}
