import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/sub_category_card.dart';

class ViewCategory extends StatefulWidget {
  CategoryModel category;
  Color? color;
  ViewCategory({Key? key, required this.category, this.color = Colors.green}) : super(key: key);

  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height - 80,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
              colors: [
            widget.color!.withOpacity(0.2),
            Colors.white,
          ])),
        child: Stack(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.category.name,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                    ),
                    Column(
                        children: widget.category.subcategories.map((e) {
                      return SubCategoryCard(
                        subcategory: e,
                        parentCategory: widget.category,
                        color: widget.color,
                      );
                    }).toList())
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
