import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';

class TicketSummaryCard extends StatefulWidget {
  const TicketSummaryCard({Key? key}) : super(key: key);

  @override
  _TicketSummaryCardState createState() => _TicketSummaryCardState();
}

class _TicketSummaryCardState extends State<TicketSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 80,
        color: Colors.white,
        shadowColor: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(8),
          width: 470,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Ticket Summary',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              table()
            ],
          ),
        ),
      ),
    );
  }

  Widget table() {
    return StreamBuilder<List<CategoryModel>>(
        stream: CategoryProvider.of(context).categoryListStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Container();
          List<CategoryModel> categoryList = snapshot.data!;
          return Container(
              child: Column(
            children: [
              const SizedBox(height: 16),
              TableRowHeading(
                heading: true,
                list: const [
                  '              ',
                  'Per ticket',
                  'QTY',
                  'Total',
                ],
              ),
              const SizedBox(height: 16),
              selectedLineItem(categoryList),
              ElevatedButton(onPressed: (){
                CheckLoginProvider.of(context)?.logout();
              }, child: Text("logut"))
            ],
          ));
        });
  }

  Widget selectedLineItem(List<CategoryModel> list) {
    List<Widget> widgetList = [];
    bool even = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i].categoryQyantity != 0) {
        List<Widget> widgetListtemp = [];
        for (int si = 0; si < list[i].subcategories.length; si++) {
          if (list[i].subcategories[si].quantity != 0) {
            even = !even;
            widgetListtemp.add(TableRowData(
              even: !even,
              name: list[i].subcategories[si].name + list[i].subcategories[si].type,
              perTicket: list[i].subcategories[si].price.toString(),
              qty: list[i].subcategories[si].quantity,
              total: list[i].subcategories[si].quantity * list[i].subcategories[si].price,
            ));
          }
        }

        widgetList.add(
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      list[i].name,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Column(
                children: widgetListtemp,
              )
            ],
          ),
        );
      }
    }
    return Column(children: widgetList);
  }
}

class TableRowHeading extends StatelessWidget {
  List<String> list;
  bool heading;
  String? title;
  TableRowHeading({
    Key? key,
    required this.list,
    this.heading = false,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      color: heading ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          cell(4, 'Name'),
          cell(2, 'per Ticket'),
          cell(1, 'QTY'),
          cell(1.5, 'Total'),
        ],
      ),
    );
  }

  Widget cell(double width, String text) {
    return Container(
      width: 50 * width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tab(Widget child) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class TableRowData extends StatelessWidget {
  final String name;
  final String perTicket;
  final int qty;
  final double total;
  final bool even;
  const TableRowData({
    Key? key,
    required this.name,
    required this.perTicket,
    required this.qty,
    required this.total,
    required this.even,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 50;
    return Container(
      color: even ? const Color(0xffE3F1E3).withOpacity(0.3) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          cell(4, '$name'),
          cell(2, '$perTicket'),
          cell(1, '$qty'),
          cell(1.5, '$total'),
        ],
      ),
    );
  }

  Widget cell(double width, String text) {
    return Container(
      width: 50 * width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
        child: Row(
          children: [
            Container(
                width: 50 * width - 16,
                child: Text(
                  text,
                  maxLines: 2,
                )),
          ],
        ),
      ),
    );
  }
}
