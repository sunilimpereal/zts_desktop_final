import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/generated_tickets.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/ticket_repository.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/sub_category_card.dart';
import 'package:zts_counter_desktop/utils/bloc.dart';

class RecentTicketBloc extends Bloc {
  BuildContext context;
  RecentTicketBloc(this.context) {
    getRecentTickets();
  }
  final _controller = BehaviorSubject<List<GeneratedTickets>>();

  Stream<List<GeneratedTickets>> get recentTicketStream => _controller.stream.asBroadcastStream();

  void getRecentTickets() async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getRecentTickets(context);
    _controller.sink.add(result);
  }

  @override
  void dispose() {
    _controller.close();
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
    return (context.dependOnInheritedWidgetOfExactType<TicketProvider>() as TicketProvider)
        .bloc;
  }
}
