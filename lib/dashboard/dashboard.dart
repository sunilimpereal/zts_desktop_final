import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import 'package:zts_counter_desktop/dashboard/counter/counter_dash.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';
import 'package:zts_counter_desktop/dashboard/printer/printer_dash.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/generated_ticket_card.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/tab_bar_selector.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/screen/ticket_summary.dart';

import 'package:zts_counter_desktop/main.dart';
import 'package:zts_counter_desktop/utils/connection_state.dart';
import 'package:zts_counter_desktop/utils/methods.dart';
import 'package:zts_counter_desktop/utils/network_status_widget.dart';

class DashBoardWrapper extends StatefulWidget {
  const DashBoardWrapper({Key? key}) : super(key: key);

  @override
  _DashBoardWrapperState createState() => _DashBoardWrapperState();
}

class _DashBoardWrapperState extends State<DashBoardWrapper> {
  @override
  Widget build(BuildContext context) {
    return CategoryProvider(
      context: context,
      child: TicketProvider(
        context: context,
        child: Dashboard(),
      ),
    );
  }
}

enum Screens {
  counter,
  tickets,
  printer,
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Screens selectedScreen = Screens.counter;

  changeScreen(Screens screens) {
    setState(() {
      selectedScreen = screens;
    });
  }

  @override
  Widget build(BuildContext context) {
    CategoryBloc categoryBloc = CategoryProvider.of(context);

    return StreamBuilder<bool>(
      stream: CheckLoginProvider.of(context)!.loggedInStream,
      builder: (context, snapshot) {
        log('loggedin : ${snapshot.data}');
        if (snapshot.hasData) {
          Future.delayed(Duration(milliseconds: 50)).then((value) {
            if (snapshot.data == false) {
              Navigator.pushReplacementNamed(context, '/login');
              // !sharedPref.loggedIn ? Navigator.pushReplacementNamed(context, '/login') : null;
            }
          });
        }
        return WinScaffold(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [topBar(), selectedScreenDisplay(categoryBloc)],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selectedScreenDisplay(CategoryBloc categoryBloc) {
    switch (selectedScreen) {
      case Screens.counter:
        return counterScreen(categoryBloc);
      case Screens.tickets:
        return ticketScreen(categoryBloc);
      case Screens.printer:
        return printerScreen(categoryBloc);
      default:
        return Container();
    }
  }

  Widget counterScreen(CategoryBloc categoryBloc) {
    return Container(
      child: Row(
        children: [
          StreamBuilder<List<CategoryModel>>(
              stream: categoryBloc.categoryListStream,
              builder: (context, snapshot) {
                return CounterDash(
                  categoryList: snapshot.data ?? [],
                );
              }),
        ],
      ),
    );
  }

  Widget ticketScreen(CategoryBloc categoryBloc) {
    return const TicketSummaryScreen();
  }

  Widget printerScreen(CategoryBloc categoryBloc) {
    return const PrinterDash();
  }

  Widget topBar() {
    final MyConnectivity _connectivity = MyConnectivity.instance;
    Map _source = {ConnectivityResult.none: false};
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TabBarSelector(
                  title: 'Counter',
                  width: 130,
                  ontap: () {
                    changeScreen(Screens.counter);
                  },
                  selected: selectedScreen == Screens.counter,
                ),
                TabBarSelector(
                  title: 'Tickets',
                  width: 130,
                  ontap: () {
                    TicketProvider.of(context).getLineItemSumry(DateTime.now());
                    changeScreen(Screens.tickets);
                  },
                  selected: selectedScreen == Screens.tickets,
                ),
                getRole() == 'admin' || getRole() == 'manager'
                    ? TabBarSelector(
                        title: 'Printer',
                        width: 130,
                        ontap: () {
                          changeScreen(Screens.printer);
                        },
                        selected: selectedScreen == Screens.printer,
                      )
                    : Container(),
                TabBarSelector(
                  title: 'Logout',
                  width: 130,
                  selected: false,
                  ontap: () {
                    CheckLoginProvider.of(context)?.logout();
                  },
                ),
              ],
            ),
            NetworkStatusWidget()
          ],
        ),
      ),
    );
  }


}
