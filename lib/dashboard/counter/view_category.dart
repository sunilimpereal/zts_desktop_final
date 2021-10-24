import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/sub_category_card.dart';

class ViewCategory extends StatefulWidget {
  CategoryModel category;
  ViewCategory({Key? key, required this.category}) : super(key: key);

  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        // width: MediaQuery.of(context).size.width*0.6,
        // color: Colors.red,
        child: Container(
            height: MediaQuery.of(context).size.height - 80,
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: Row(
              children: [
                Column(
                  children: [
                    Text(widget.category.name),
                    Column(
                        children: widget.category.subcategories.map((e) {
                      return SubCategoryCard(subcategory: e);
                    }).toList())
                  ],
                ),
              ],
            )));
  }
}
