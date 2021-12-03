import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/repository/ticket_bloc.dart';
import 'package:zts_counter_desktop/main.dart';

class ZTSDurationDropdown extends StatefulWidget {
  final Function(bool) onChanged;
  const ZTSDurationDropdown({Key? key, required this.onChanged}) : super(key: key);

  @override
  _ZTSDurationDropdownState createState() => _ZTSDurationDropdownState();
}

class _ZTSDurationDropdownState extends State<ZTSDurationDropdown> {
  List<String> options = ['Last hour', 'Today'];
  late String selected;
  @override
  void initState() {
    selected = options[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: Container(),
        style: TextStyle(color: Colors.green, fontFamily: appFonts.notoSans, fontSize: 16),
        value: selected,
        onChanged: (value) {
          setState(() {
            selected = value ?? 'Last hour';
            if (value == options[1]) {
              widget.onChanged(false);
              TicketProvider.of(context).getTicketReport(showonlyHour: false);
            } else {
              TicketProvider.of(context).getTicketReport(showonlyHour: true);

              widget.onChanged(true);
            }
          });
        },
      ),
    );
  }
}
