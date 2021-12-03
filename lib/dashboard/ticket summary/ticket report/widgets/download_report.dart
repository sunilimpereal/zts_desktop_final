import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket_report_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/ticket%20report/widgets/excelGen.dart';

import '../../../../main.dart';
import '../../data/repository/ticket_bloc.dart';

class DownloadTicketReport extends StatefulWidget {
  const DownloadTicketReport({Key? key}) : super(key: key);

  @override
  _DownloadTicketReportState createState() => _DownloadTicketReportState();
}

class _DownloadTicketReportState extends State<DownloadTicketReport> {
  String selected = "";
  bool opened = false;
  OverlayEntry? entry;
  final layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
  }

  showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            opened = !opened;
          });

          hideOverlay();
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                child: CompositedTransformFollower(
                    link: layerLink,
                    offset: Offset(
                      -MediaQuery.of(context).size.width * 0.1 * 1,
                      32,
                    ),
                    showWhenUnlinked: false,
                    child: buildOverlay()),
              ),
            ],
          ),
        ),
      ),
    );
    overlay?.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  Widget buildOverlay() {
    return TicketProvider(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Material(
          elevation: 15,
          shadowColor: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.hardEdge,
          child: Container(
            color: Colors.transparent,
            child: ReportDownloadOptions(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: layerLink,
        child: Container(
            width: 36,
            height: 36,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                0,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.download,
                size: 28,
                color: Colors.green,
              ),
              onPressed: () {
                setState(() {
                  opened = !opened;
                  showOverlay();
                });
              },
            )));
  }
}

class ReportDownloadOptions extends StatefulWidget {
  const ReportDownloadOptions({Key? key}) : super(key: key);

  @override
  _ReportDownloadOptionsState createState() => _ReportDownloadOptionsState();
}

class _ReportDownloadOptionsState extends State<ReportDownloadOptions> {
  List<String> options = ['Last hour', 'Today'];
  late String selected;
  bool loading = false;
  bool excelloading = false;
  bool allUsers = true;
  FocusNode userEmailFocus = new FocusNode();
  TextEditingController userEmailTextEditingController = new TextEditingController();

  void _onAllUserChanged(bool? newValue) => setState(() {
        allUsers = newValue ?? false;

        if (allUsers) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });

  @override
  void initState() {
    selected = options[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      shadowColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.1 * 2,
        height: MediaQuery.of(context).size.height * 0.2 * (allUsers ? 0.8 : 1),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Report',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Text(
                            'Select All Users',
                            style: TextStyle(),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Checkbox(
                            value: allUsers,
                            onChanged: _onAllUserChanged,
                            activeColor: Colors.green,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Tooltip(
                              message:
                                  "Downloads Report of all Users.\nUncheck to download report of a single user",
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.grey[500]),
                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              child: Icon(
                                Icons.info,
                                size: 18,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      !allUsers
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                    width: 2,
                                    color: userEmailFocus.hasFocus
                                        ? Colors.green
                                        : Colors.transparent),
                              ),
                              child: Material(
                                elevation: userEmailFocus.hasFocus ? 0 : 0,
                                color: Theme.of(context).colorScheme.background,
                                shape: appStyles.shapeBorder(5),
                                shadowColor: Colors.grey[100],
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 0.7,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: TextFormField(
                                    controller: userEmailTextEditingController,
                                    focusNode: userEmailFocus,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).textTheme.headline1!.color,
                                      // AppConfig(context).width<1000?16: 18,
                                      // fontFamily: appFonts.notoSans,//TODO: fonts
                                      fontWeight: FontWeight.w600,
                                    ),
                                    onTap: () {},
                                    onChanged: (value) {},
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      // errorText: "${snapshot.error}",
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          left: 0, right: 10, top: 10, bottom: 10),
                                      hintText: "user email",
                                      prefixIconConstraints:
                                          const BoxConstraints(minWidth: 23, maxHeight: 0),

                                      isDense: false,
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .color
                                              ?.withOpacity(0.5),
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
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.green.shade100.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loading
                        ? 'Fetching Ticket Report..'
                        : excelloading
                            ? "Opening Excel.."
                            : ""),
                    StreamBuilder<List<TicketReportItem>>(
                        stream: TicketProvider.of(context).ticketReportStream,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              TicketProvider.of(context)
                                  .getTicketReport(showonlyHour: false)
                                  .then((value) async {
                                setState(() {
                                  loading = false;
                                });
                                List<TicketReportItem> ticketReportList = value;
                                if (!allUsers) {
                                  ticketReportList = ticketReportList
                                      .where((element) =>
                                          element.userEmail.toLowerCase() ==
                                          userEmailTextEditingController.text.toLowerCase().trim())
                                      .toList();
                                }
                                log("asdaa" + value.toString());
                                setState(() {
                                  excelloading = true;
                                });
                                await ExcelGenerator().createExcel(ticketReportList);
                                setState(() {
                                  excelloading = false;
                                });
                              });
                            },
                            child: !loading
                                ? Text(
                                    'Download',
                                  )
                                : Container(
                                    width: 16,
                                    height: 16,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                          );
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
