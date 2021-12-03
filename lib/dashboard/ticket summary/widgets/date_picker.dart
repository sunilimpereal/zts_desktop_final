import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/line_summary_model.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';

class ZTSDatePicker extends StatefulWidget {
  final Function(dynamic) onSelectionChanged;
  const ZTSDatePicker({Key? key, required this.onSelectionChanged}) : super(key: key);

  @override
  _ZTSDatePickerState createState() => _ZTSDatePickerState();
}

class _ZTSDatePickerState extends State<ZTSDatePicker> {
  OverlayEntry? entry;
  final layerLink = LayerLink();

  showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          hideOverlay();
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                width: MediaQuery.of(context).size.width * 0.3,
                child: CompositedTransformFollower(
                    link: layerLink,
                    offset: Offset(0, size.height),
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
    return Material(
      elevation: 8,
      shadowColor: Colors.white,
      child: Container(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.3,
        color: Colors.white,
        child: SfDateRangePicker(
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            setState(() {
              hideOverlay();
              widget.onSelectionChanged(args.value);
            });
          },
          selectionColor: Colors.green,
          todayHighlightColor: Colors.green,
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: TicketProvider.of(context).selectedDate,
          initialSelectedRange: PickerDateRange(DateTime.now().subtract(const Duration(days: 4)),
              DateTime.now().add(const Duration(days: 3))),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: layerLink,
        child: StreamBuilder<List<LineSumryItem>>(
            stream: TicketProvider.of(context).lineItemSummary,
            builder: (context, snapshot) {
              return TextButton(
                  
                  onPressed: () {
                    showOverlay();
                  },
                  child: Text(DateFormat.yMMMEd().format(TicketProvider.of(context).selectedDate)));
            }));
  }
}
