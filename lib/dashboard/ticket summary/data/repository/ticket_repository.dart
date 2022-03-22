import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket_report_model.dart';
import 'package:zts_counter_desktop/repository/repositry.dart';
import 'package:zts_counter_desktop/utils/methods.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

import '../../../../main.dart';

class TicketRepository {
  Future<List<GeneratedTickets>> getRecentTickets(
      {required BuildContext context, required bool showonlyHour}) async {
    DateTime date = DateTime.now();
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    // ${date.day}
    final response = await API.get(
        url:
            'ticket/?issued_ts__year=${date.year}&issued_ts__month=${date.month}&issued_ts__day=${date.day}${showonlyHour ? "&issued_ts__hour=${date.hour}&issued_ts__minute=${date.minute}" : ""}',
        context: context,
        logs: true,
        headers1: headers);
    if (response.statusCode == 200) {
      List<GeneratedTickets> ticketList = generatedTicketsFromJson(response.body);
      ticketList.sort((b, a) {
        return a.issuedTs.compareTo(b.issuedTs);
      });
      getRole() != 'admin'
          ? ticketList = ticketList
              .where((element) => element.userEmail == "${sharedPrefs.userEmail}")
              .toList()
          : null;
      return ticketList;
    } else {
      return [];
    }
  }

  Future<List<TicketReportItem>> getTicketReport(
      {required BuildContext context, required bool showonlyHour, DateTime? seldate}) async {
    DateTime date = seldate ?? DateTime.now();
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    // ${date.day}
    final response = await API.get(
        url:
            'ticket_report/?issued_ts__year=${date.year}&issued_ts__month=${date.month}&issued_ts__day=${date.day}${showonlyHour ? "&issued_ts__hour=${date.hour}" : ""}',
        //  url:
        //      'ticket_report/?issued_ts__year=2021&issued_ts__month=12',

        context: context,
        logs: true,
        headers1: headers);
    if (response.statusCode == 200) {
      List<TicketReportItem> ticketList = ticketReportItemFromJson(response.body);
      ticketList.sort((b, a) {
        log("fine:" + a.fine.toString());
        return a.issuedTs.compareTo(b.issuedTs);
      });
      getRole() != 'admin'
          ? ticketList =
              ticketList.where((element) => element.userEmail == sharedPrefs.userEmail).toList()
          : null;
      return ticketList;
    } else {
      return [];
    }
  }

  Future<List<TicketReportItem>> getMonthTicketReport(
      {required BuildContext context,
      required bool showonlyHour,
      DateTime? seldate,
      required int month,
      required int year}) async {
    DateTime date = seldate ?? DateTime.now();
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    // ${date.day}
    final response = await API.get(
        url: 'ticket_report/?issued_ts__year=${year}&issued_ts__month=${month}',
        //  url:
        //      'ticket_report/?issued_ts__year=2021&issued_ts__month=12',

        context: context,
        logs: true,
        headers1: headers);
    if (response.statusCode == 200) {
      List<TicketReportItem> ticketList = ticketReportItemFromJson(response.body);
      ticketList.sort((b, a) {
        log("fine:" + a.fine.toString());
        return a.issuedTs.compareTo(b.issuedTs);
      });
      getRole() != 'admin'
          ? ticketList =
              ticketList.where((element) => element.userEmail == sharedPrefs.userEmail).toList()
          : null;
      return ticketList;
    } else {
      return [];
    }
  }

  Future<List<LineSumryItem>> getFiletredLineItems(BuildContext context, DateTime date) async {
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    final response = await API.get(
        logs: true,
        headers1: headers,
        url: getRole() == 'admin' || getRole() == 'manager'
            ? 'get-lineitems/?start_date=${date.toString().substring(0, 10)}&end_date=${date.toString().substring(0, 10)}'
            : 'get-lineitems/?user_email=${sharedPrefs.userEmail}&start_date=${date.toString().substring(0, 10)}&end_date=${date.toString().substring(0, 10)}',
        context: context);
    if (response.statusCode == 200) {
      List<LineSumryItem> ticketList = lineSumryItemFromJson(response.body);

      return ticketList;
    } else {
      return [];
    }
  }
}
