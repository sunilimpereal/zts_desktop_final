import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
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
      return ticketList;
    } else {
      return [];
    }
  }
}
