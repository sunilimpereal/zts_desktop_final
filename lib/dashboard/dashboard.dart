import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import 'package:zts_counter_desktop/dashboard/counter/counter_dash.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/tab_bar_selector.dart';

import 'package:zts_counter_desktop/main.dart';

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
      child: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                  body: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          child: topBar(),
                        ),
                        Row(
                          children: [
                            StreamBuilder<List<CategoryModel>>(
                                stream: categoryBloc.categoryListStream,
                                builder: (context, snapshot) {
                                  return CounterDash(
                                    categoryList: snapshot.data ?? [],
                                  );
                                }),
                          ],
                        )
                      ],
                    ),
                  )));
        });
  }

  Widget topBar() {
    return Row(
      children: const [
        TabBarSelector(
          title: 'Counter',
          width: 130,
        ),
      ],
    );
  }
}
