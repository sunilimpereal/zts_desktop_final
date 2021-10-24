import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';

class SubCategoryCard extends StatefulWidget {
  final Subcategory subcategory;
  const SubCategoryCard({Key? key, required this.subcategory}) : super(key: key);

  @override
  _SubCategoryCardState createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.all(8),
            width: 600,
            height: 80,
            color: Colors.white,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.subcategory.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Theme.of(context).primaryColor)),
                    Text('\$ ${widget.subcategory.price.toString()}')
                  ],
                ),
                quantity()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget quantity() {
    return Container(
      child: Row(
        children: [
          iconCounter(
            icon: Icons.remove,
          ),
        ],
      ),
    );
  }

  Widget iconCounter({required IconData icon}) {
    return Material(
      color: Colors.green,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 42,
          height: 42,
          child: Center(
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
