import 'dart:developer';

import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository_bloc.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';
import 'package:zts_counter_desktop/main.dart';
import 'package:zts_counter_desktop/printer/bill_pdf.dart';
import 'package:zts_counter_desktop/utils/methods.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

class TicketSummaryCard extends StatefulWidget {
  const TicketSummaryCard({Key? key}) : super(key: key);

  @override
  _TicketSummaryCardState createState() => _TicketSummaryCardState();
}

class _TicketSummaryCardState extends State<TicketSummaryCard> {
  bool loadingPrintButton = false;
  FocusNode vehicleNumberFocus = FocusNode();
  TextEditingController vehicleNumberController = TextEditingController();
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
          height: MediaQuery.of(context).size.height * 0.88,
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 0.25,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          'Ticket Summary',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TableRowHeading(
                    heading: true,
                  ),
                  table(),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width * 0.24,
                  color: Colors.white.withOpacity(0.9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder<CategoryModel>(
                          stream: CategoryProvider.of(context).selectedcategoryStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            if (snapshot.data!.name.toLowerCase().contains('parking')) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  // Text("Vechile Number: "),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width * 0.22,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                          width: 2,
                                          color: vehicleNumberFocus.hasFocus
                                              ? Theme.of(context).colorScheme.primary
                                              : Colors.transparent),
                                    ),
                                    child: Material(
                                      elevation: vehicleNumberFocus.hasFocus ? 0 : 0,
                                      color: Theme.of(context).colorScheme.background,
                                      shape: appStyles.shapeBorder(5),
                                      shadowColor: Colors.grey[100],
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width * 0.7,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: TextFormField(
                                          controller: vehicleNumberController,
                                          focusNode: vehicleNumberFocus,
                                          textAlign: TextAlign.left,
                                          obscureText: false,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).textTheme.headline1!.color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          onTap: () {},
                                          onChanged: (value) {
                                            // vehicleNumberController.text = value.toUpperCase();
                                            sharedPrefs.setVehicleNumber(vehicleNumber: value);
                                          },
                                          inputFormatters: [
                                            UpperCaseTextFormatter(),
                                          ],
                                          decoration: InputDecoration(
                                            // errorText: "${snapshot.error}",
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.only(
                                                left: 0, right: 10, top: 10, bottom: 10),
                                            hintText: "Vehicle Number",
                                            prefixIconConstraints:
                                                const BoxConstraints(minWidth: 23, maxHeight: 20),
                                            labelText: "Vehicle Number",
                                            isDense: false,
                                            hintStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .color
                                                    ?.withOpacity(0.2),
                                                fontSize: 16),
                                            labelStyle: TextStyle(
                                              height: 0.6,
                                              fontSize: 16,
                                              color: Theme.of(context).textTheme.headline1!.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              );
                            } else {
                              return Container();
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'TOTAL',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<List<CategoryModel>>(
                                stream: CategoryProvider.of(context).categoryListStream,
                                builder: (context, snapshot) {
                                  return Text(
                                    '₹ ${getTotalCategory(snapshot.data ?? [])} /- ',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 24,
                                      fontFamily: appFonts.notoSans,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                CategoryProvider.of(context).getCategoryList();
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ),
                          StreamBuilder<List<CategoryModel>>(
                              stream: CategoryProvider.of(context).categoryListStream,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  width: 200,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: loadingPrintButton
                                        ? () {}
                                        : () async {
                                            setState(() {
                                              loadingPrintButton = true;
                                            });
                                            if (await hasNetwork()) {
                                              createFolderInAppDocDir('bills');
                                              log(getTotalCategory(snapshot.data ?? []).toString());
                                              if ((getTotalCategory(snapshot.data ?? []) != 0)) {
                                                CategoryRepository categoryRepository =
                                                    CategoryRepository();
                                                List<CategoryModel> categorylist =
                                                    snapshot.data ?? [];
                                                log(categorylist.toString());
                                                List<CategoryModel> filterCategorylist = [];

                                                for (CategoryModel category in categorylist) {
                                                  if (category.categoryQyantity != 0) {
                                                    if (category.name.contains('Parking')) {
                                                      await categoryRepository.generateTicket(
                                                          context: context,
                                                          categorylist: [category]).then((value) {
                                                        log(value.toString());
                                                      });
                                                      continue;
                                                    }
                                                    if (category.name.contains('Locker')) {
                                                      await categoryRepository.generateTicket(
                                                          context: context,
                                                          categorylist: [category]).then((value) {
                                                        log(value.toString());
                                                      });
                                                      continue;
                                                    }
                                                    if (category.name
                                                        .contains('Battery Operated Vehicle')) {
                                                      await categoryRepository.generateTicket(
                                                          context: context,
                                                          categorylist: [category]).then((value) {
                                                        log(value.toString());
                                                      });
                                                      continue;
                                                    }

                                                    filterCategorylist.add(category);
                                                  }
                                                }
                                                filterCategorylist.isNotEmpty
                                                    ? await categoryRepository
                                                        .generateTicket(
                                                            context: context,
                                                            categorylist: filterCategorylist)
                                                        .then((value) {
                                                        log(value.toString());
                                                      })
                                                    : null;
                                                setState(() {
                                                  vehicleNumberController.clear();
                                                  log('message loading');
                                                  loadingPrintButton = !CategoryProvider.of(context)
                                                      .updateCategorytZero(convertCategorytoZero(
                                                          snapshot.data ?? []));
                                                });
                                                TicketProvider.of(context).getRecentTickets();
                                              } else {
                                                setState(() {
                                                  loadingPrintButton = false;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                loadingPrintButton = false;
                                              });
                                            }
                                          },
                                    child: loadingPrintButton
                                        ? const Center(
                                            child: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const Text(
                                            'PRINT',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              
              
              
              )
            ],
          ),
        ),
      ),
    );
  }

  List<CategoryModel> convertCategorytoZero(List<CategoryModel> list) {
    List<CategoryModel> newList = list;
    for (CategoryModel categoryModel in newList) {
      categoryModel.categoryQyantity = 0;
      for (Subcategory subCategory in categoryModel.subcategories) {
        subCategory.quantity = 0;
      }
    }
    return newList;
  }

  int getTotalCategory(List<CategoryModel> list) {
    int sum = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].categoryQyantity != 0) {
        for (int si = 0; si < list[i].subcategories.length; si++) {
          if (list[i].subcategories[si].quantity != 0) {
            sum =
                sum + (list[i].subcategories[si].quantity * list[i].subcategories[si].price).ceil();
          }
        }
      }
    }
    return sum;
  }

  Widget table() {
    return StreamBuilder<List<CategoryModel>>(
        stream: CategoryProvider.of(context).categoryListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          List<CategoryModel> categoryList = snapshot.data!;
          return Container(
            height: MediaQuery.of(context).size.height * 0.72,
            child: SingleChildScrollView(
              child: Container(
                  child: Column(
                children: [
                  selectedLineItem(categoryList),
                  SizedBox(
                    height: 150,
                  )
                ],
              )),
            ),
          );
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
              name: list[i].subcategories[si].name + ' ' + list[i].subcategories[si].type,
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
                  horizontal: 4,
                ),
                child: Row(
                  children: [
                    Text(
                      list[i].name,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
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

class TableRowHeading extends StatefulWidget {
  bool heading;
  String? title;
  TableRowHeading({
    Key? key,
    this.heading = false,
    this.title,
  }) : super(key: key);

  @override
  State<TableRowHeading> createState() => _TableRowHeadingState();
}

class _TableRowHeadingState extends State<TableRowHeading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      color: widget.heading ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          cell(4, 'Name'),
          cell(2.12, 'Per Ticket'),
          cell(1.1, 'QTY'),
          cell(2, 'Total'),
        ],
      ),
    );
  }

  Widget cell(double width, String text) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.024 * width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.024 * width - 8,
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
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

class TableRowData extends StatefulWidget {
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
  State<TableRowData> createState() => _TableRowDataState();
}

class _TableRowDataState extends State<TableRowData> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.024;
    return Container(
      color: widget.even ? const Color(0xffE3F1E3).withOpacity(0.3) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          cell(4, '${widget.name}'),
          cell(2, '${widget.perTicket}'),
          cell(1, '${widget.qty}'),
          cell(2, '${widget.total}'),
        ],
      ),
    );
  }

  Widget cell(double width, String text) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.024 * width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.024 * width - 16,
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
