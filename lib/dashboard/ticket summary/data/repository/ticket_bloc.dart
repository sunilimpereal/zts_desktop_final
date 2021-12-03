import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket_report_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_repository.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/sub_category_card.dart';
import 'package:zts_counter_desktop/utils/bloc.dart';

class RecentTicketBloc extends Bloc {
  BuildContext context;
  RecentTicketBloc(this.context) {
    _ticektReportLoadingController.sink.add(true);
    getRecentTickets();
    getTicketReport();
    getLineItemSumry(DateTime.now());
  }
  final _recentTicektcontroller = BehaviorSubject<List<GeneratedTickets>>();
  final _ticektReportcontroller = BehaviorSubject<List<TicketReportItem>>();
  final _ticektReportLoadingController = BehaviorSubject<bool>();
  final _lineItemSumrycontroller = BehaviorSubject<List<LineSumryItem>>();
  DateTime selectedDate = DateTime.now();
  DateTime ticketReportselectedDate = DateTime.now();
  bool ticketReportisHour = true;
  Stream<List<GeneratedTickets>> get recentTicketStream =>
      _recentTicektcontroller.stream.asBroadcastStream();
  Stream<List<TicketReportItem>> get ticketReportStream =>
      _ticektReportcontroller.stream.asBroadcastStream();
  Stream<bool> get ticketReportLoadingStream =>
      _ticektReportLoadingController.stream.asBroadcastStream();
  Stream<List<LineSumryItem>> get lineItemSummary =>
      _lineItemSumrycontroller.stream.asBroadcastStream();

  void getRecentTickets() async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getRecentTickets(context: context, showonlyHour: true);
    _recentTicektcontroller.sink.add(result);
  }

  Future<List<TicketReportItem>> getTicketReport({bool? showonlyHour}) async {
    ticketReportisHour = showonlyHour ?? true;
    TicketRepository ticketRepository = TicketRepository();
    _ticektReportLoadingController.sink.add(true);
    final result = await ticketRepository.getTicketReport(
        context: context, showonlyHour: showonlyHour ?? true);
    _ticektReportLoadingController.sink.add(false);
    _ticektReportcontroller.sink.add(result);
    return result;
  }

  void getLineItemSumry(DateTime date) async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getFiletredLineItems(context, date);
    selectedDate = date;
    _lineItemSumrycontroller.sink.add(result);
  }

  @override
  void dispose() {
    _recentTicektcontroller.close();
    _ticektReportcontroller.close();
  }
}

class TicketProvider extends InheritedWidget {
  late RecentTicketBloc bloc;
  BuildContext context;
  TicketProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = RecentTicketBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static RecentTicketBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<TicketProvider>() as TicketProvider).bloc;
  }
}
