import 'package:flutter/material.dart';

class TabBarSelector extends StatefulWidget {
  final String title;
  final double width;
  const TabBarSelector({
    Key? key,
    required this.title,
    required this.width,
  }) : super(key: key);

  @override
  _TabBarSelectorState createState() => _TabBarSelectorState();
}

class _TabBarSelectorState extends State<TabBarSelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            width: widget.width,
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 4,
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        8,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
