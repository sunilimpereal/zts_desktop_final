import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

class PrinterDash extends StatefulWidget {
  const PrinterDash({Key? key}) : super(key: key);

  @override
  _PrinterDashState createState() => _PrinterDashState();
}

class _PrinterDashState extends State<PrinterDash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Printer",style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              
              color: Theme.of(context).primaryColor
            ),),
            SizedBox(height:15),
            printerList(),
          ],
        ),
      ),
    );
  }

  Widget printerList() {
    return Container(
      child: FutureBuilder<List<Printer>>(
        future: Printing.listPrinters(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          List<Printer> printers = snapshot.data!;
          return Container(
            height: MediaQuery.of(context).size.height*0.79,
            child: SingleChildScrollView(
              child: Column(
                  children: printers
                      .map((e) => Material(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  sharedPrefs.setPrinter(printer: e.name);
                                });
                              },
                              child: Container(
                                  height: 80,
                                  width: 400,
                                  child: Row(
                                    children: [
                                       SizedBox(
                                        width: 15,
                                      ),
                                      Icon(Icons.print),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(e.name),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      sharedPrefs.getPrinter == e.name
                                          ? Icon(Icons.check_circle)
                                          : Container(),
                                    ],
                                  )),
                            ),
                          ))
                      .toList()),
            ),
          );
        },
      ),
    );
  }
}
