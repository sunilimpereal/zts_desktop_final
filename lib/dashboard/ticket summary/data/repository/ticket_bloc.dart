import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_repository.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/sub_category_card.dart';
import 'package:zts_counter_desktop/utils/bloc.dart';

class RecentTicketBloc extends Bloc {
  BuildContext context;
  RecentTicketBloc(this.context) {
    getRecentTickets();
    getTicketHistory();
    getLineItemSumry();
  }
  final _recentTicektcontroller = BehaviorSubject<List<GeneratedTickets>>();
  final _ticektHistorycontroller = BehaviorSubject<List<GeneratedTickets>>();
  final _lineItemSumrycontroller = BehaviorSubject<List<LineSumryItem>>();

  Stream<List<GeneratedTickets>> get recentTicketStream =>
      _recentTicektcontroller.stream.asBroadcastStream();
  Stream<List<GeneratedTickets>> get ticketHistoryStream =>
      _ticektHistorycontroller.stream.asBroadcastStream();
        Stream<List<LineSumryItem>> get lineItemSummary =>
      _lineItemSumrycontroller.stream.asBroadcastStream();

  void getRecentTickets() async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getRecentTickets(context);
    _recentTicektcontroller.sink.add(result);
  }

  void getTicketHistory() async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getRecentTickets(context);
    _ticektHistorycontroller.sink.add(result);
  }

    void getLineItemSumry() async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getFiletredLineItems(context);
    _lineItemSumrycontroller.sink.add(result);
  }

  @override
  void dispose() {
    _recentTicektcontroller.close();
    _ticektHistorycontroller.close();
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
