import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/category_section.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';
import 'package:zts_counter_desktop/dashboard/counter/view_category.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/generated_ticket_card.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/ticket_summary_card.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:zts_counter_desktop/main.dart';

class CounterDash extends StatefulWidget {
  List<CategoryModel> categoryList;
  CounterDash({Key? key, required this.categoryList}) : super(key: key);

  @override
  _CounterDashState createState() => _CounterDashState();
}

class _CounterDashState extends State<CounterDash> {
  late CategoryModel selectedCategory;
  List<Color> cardColors = [
    const Color(0xff008832),
    const Color(0xff62b6cb),
    const Color(0xff3d348b),
    const Color(0xff56282D),
    const Color(0xfffa824c),
    const Color(0xFFA8201A),
    const Color(0xff3d348b),
    const Color(0xff56282D),
    const Color(0xfffa824c),
    const Color(0xFFA8201A),
    const Color(0xff62b6cb),
    const Color(0xff3d348b),
    const Color(0xff56282D),
    const Color(0xfffa824c),
    const Color(0xFFA8201A),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CategoryModel>(
        stream: CategoryProvider.of(context).selectedcategoryStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: Stack(
              children: [
                Row(
                  children: [
                    CategorySelection(
                      colorIndex: widget.categoryList.indexOf(snapshot.data!),
                      categoryList: widget.categoryList,
                      selectedCategory: snapshot.data!,
                      onChanged: (CategoryModel categoryModel) {
                        CategoryProvider.of(context).updateSelectedCategory(categoryModel);
                      },
                      colorList: cardColors,
                    ),
                    ViewCategory(
                      category: snapshot.data!,
                      color: cardColors[widget.categoryList.indexOf(snapshot.data!)],
                    )
                  ],
                ),
                '${snapshot.data?.name}' != 'Bottle'
                    ? const Positioned(right: 0, child: TicketSummaryCard())
                    : Container(),
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 400,
                      height: 80,
                      child: TicketDisplay(),
                    )
                    )
              ],
            ),
          );
        });
  }
}
