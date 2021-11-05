import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/category_card.dart';

class CategorySelection extends StatefulWidget {
  List<CategoryModel> categoryList;
  CategoryModel selectedCategory;
  Function(CategoryModel) onChanged;
  List<Color> colorList;
  int colorIndex;
  CategorySelection(
      {Key? key,
      required this.categoryList,
      required this.selectedCategory,
      required this.colorList,
      required this.onChanged,required this.colorIndex})
      : super(key: key);

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      height: MediaQuery.of(context).size.height - 82,
      width: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
              colors: [
            Colors.green.withOpacity(0.05),
            Colors.white,
          ])),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
        children: List.generate(widget.categoryList.length, (index) {
          return CategoryCard(
            color:widget.colorList[index],
            categoryModel: widget.categoryList[index],
            active: widget.categoryList[index].id == widget.selectedCategory.id,
            onchanged: widget.onChanged,
          );
        }),
      ),
    );
  }
}
