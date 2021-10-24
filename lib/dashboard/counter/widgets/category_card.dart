import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/svg_icon.dart';
import 'package:zts_counter_desktop/main.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel categoryModel;
  final bool active;
  final Color color;
  final Function(CategoryModel) onchanged;
  const CategoryCard(
      {Key? key,
      required this.categoryModel,
      required this.color,
      required this.active,
      required this.onchanged})
      : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    CategoryBloc categoryBloc = CategoryProvider.of(context);
    return Container(
      width: 100,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 25,
            spreadRadius: 0.5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        shadowColor: Colors.grey[100],
        elevation: widget.active ? 10 : 0,
        color: widget.active ? widget.color : Colors.white,
        type: MaterialType.button,
        child: InkWell(
          onTap: () {
            setState(() {
              widget.onchanged(widget.categoryModel);
            });
          },
          splashColor: widget.color..withOpacity(0.5),
          highlightColor: widget.color.withOpacity(0.2),
          child: Container(
            height: 200,
            width: 180,
            decoration: BoxDecoration(
              border: Border.all(color: widget.color, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.categoryModel.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.active ? Colors.white : widget.color,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: SvgIcon(
                          color: widget.active ? Colors.white : widget.color,
                          path: '${widget.categoryModel.name}.svg',
                        ))
                  ],
                ),
                const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
