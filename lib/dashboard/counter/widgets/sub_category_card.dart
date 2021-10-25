import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';

class SubCategoryCard extends StatefulWidget {
  final Subcategory subcategory;
  final CategoryModel parentCategory;
  final Color? color;
  const SubCategoryCard(
      {Key? key,
      required this.subcategory,
      this.color = Colors.green,
      required this.parentCategory})
      : super(key: key);

  @override
  _SubCategoryCardState createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  TextEditingController quantityController = TextEditingController();
  FocusNode quanityFocus = FocusNode();

  @override
  void initState() {
    quantityController.text = widget.subcategory.quantity.toString();
    quanityFocus.addListener(() {
      log("message listner");

      setState(() {});
    });
    super.initState();
  }

  update() {
    if (!quanityFocus.hasFocus) {
      quantityController.text = widget.subcategory.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    update();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 16,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.transparent,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.hardEdge,
          shadowColor: Colors.green[50],
          child: InkWell(
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 600,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.subcategory.name + " " + widget.subcategory.type,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: widget.color)),
                      Text('₹ ${widget.subcategory.price.toString()}')
                    ],
                  ),
                  quantity()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  increment() {
    setState(() {
      int a = int.parse(quantityController.text) + 1;
      CategoryProvider.of(context).updateCategoryQuantity(
        categoryId: widget.parentCategory.id,
        subCategoryId: widget.subcategory.id,
        quantity: a,
      );
    });
  }

  decrement() {
    setState(() {
      if (quantityController.text != "0") {
        int a = int.parse(quantityController.text) - 1;
        CategoryProvider.of(context).updateCategoryQuantity(
          categoryId: widget.parentCategory.id,
          subCategoryId: widget.subcategory.id,
          quantity: a,
        );
      } else {}
    });
  }

  Widget quantity() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconCounter(
            icon: Icons.remove,
            ontap: () {
              decrement();
            },
          ),
          Container(
            width: 60,
            child: EditableText(
              maxLines: 1,
              textAlign: TextAlign.center,
              controller: quantityController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (a) {
                CategoryProvider.of(context).updateCategoryQuantity(
                  categoryId: widget.parentCategory.id,
                  subCategoryId: widget.subcategory.id,
                  quantity: int.parse(quantityController.text),
                );
              },
              focusNode: quanityFocus,
              style: TextStyle(color:widget.color, fontSize: 32),
              backgroundCursorColor: Colors.greenAccent,
              cursorColor: Colors.green,
            ),
          ),
          iconCounter(
            icon: Icons.add,
            ontap: () {
              increment();
            },
          ),
        ],
      ),
    );
  }

  Widget iconCounter({required IconData icon, required Function ontap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        child: InkWell(
          onTap: () {
            ontap();
          },
          child: Container(
            width: 42,
            height: 42,
           
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    quantityController.text = '0';
    super.dispose();
  }
}
