import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/repository/repositry.dart';

class TicketRepository {
  Future<List<GeneratedTickets>> getRecentTickets(BuildContext context) async {
    DateTime date = DateTime.now();
    final response = await API.get(
        url:
            'ticket/?issued_ts__year=${date.year}&issued_ts__month=${date.month}&issued_ts__day=${date.day}',
        context: context);
    if (response.statusCode == 200) {
      List<GeneratedTickets> ticketList = generatedTicketsFromJson(response.body);
      ticketList.sort((b, a) {
        return a.issuedTs.compareTo(b.issuedTs);
      });
      return ticketList;
    } else {
      return [];
    }
  }

    Future<List<LineSumryItem>> getFiletredLineItems(BuildContext context) async {
    DateTime date = DateTime.now();
    final response = await API.get(
        url:
            'get-lineitems/?start_date=${date.toString().substring(0,10)}&end_date=${date.toString().substring(0,10)}',
        context: context);
    if (response.statusCode == 200) {
      List<LineSumryItem> ticketList = lineSumryItemFromJson(response.body);
      return ticketList;
    } else {
      return [];
    }
  }





}
