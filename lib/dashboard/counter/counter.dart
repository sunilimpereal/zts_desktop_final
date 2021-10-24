import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/category_section.dart';
import 'package:zts_counter_desktop/dashboard/counter/view_category.dart';

class CounterDash extends StatefulWidget {
  List<CategoryModel> categoryList;
  CounterDash({Key? key, required this.categoryList}) : super(key: key);

  @override
  _CounterDashState createState() => _CounterDashState();
}

class _CounterDashState extends State<CounterDash> {
  late CategoryModel selectedCategory;
  @override
  void initState() {
    selectedCategory = widget.categoryList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width-32,
      child: Row(
        children: [
          CategorySelection(
            categoryList: widget.categoryList,
            selectedCategory:selectedCategory,
            onChanged: (CategoryModel categoryModel) {
              setState(() {
                selectedCategory = categoryModel;
              });
            },
          ),
          ViewCategory(category: selectedCategory)




        ],
      ),
    );
  }
}
