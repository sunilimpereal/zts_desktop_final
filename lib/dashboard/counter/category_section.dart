import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/category_card.dart';

class CategorySelection extends StatefulWidget {
  List<CategoryModel> categoryList;
  CategoryModel selectedCategory;
  Function(CategoryModel) onChanged;
  CategorySelection(
      {Key? key,
      required this.categoryList,
      required this.selectedCategory,
      required this.onChanged})
      : super(key: key);

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  List<Color> cardColors = [
   const  Color(0xff008832),
   const  Color(0xff183869),
   const  Color(0xff1C88A2),
   const  Color(0xff8AC5C1),
   const  Color(0xff14846D),
   const  Color(0xFFFD998C),
   const  Color(0xff),
   const  Color(0xff),
   const  Color(0xff),
   const  Color(0xff),
   const  Color(0xff),
  ];
  @override
  Widget build(BuildContext context) {
    CategoryBloc categoryBloc = CategoryProvider.of(context);
    return Container(
      color: Colors.green.withOpacity(0.1),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height - 80,
      width: MediaQuery.of(context).size.width * 0.35,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        children: List.generate(widget.categoryList.length, (index) {
          return CategoryCard(
            color: cardColors[index],
            categoryModel: widget.categoryList[index],
            active: widget.categoryList[index].id == widget.selectedCategory.id,
            onchanged: widget.onChanged,
          );
        }),
      ),
    );
  }
}
