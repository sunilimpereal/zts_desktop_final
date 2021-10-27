import 'dart:developer';

import 'package:flutter/material.dart';

class ZTSStreamButton extends StatefulWidget {
  Stream<List<String>> formValidationStream;
  Function submit;
  String text;
  String errrorText;
  bool errorFlag;

  //width
  double? width;
  ZTSStreamButton({
    Key? key,
    required this.formValidationStream,
    required this.submit,
    required this.text,
    this.width,
    required this.errrorText,
    required this.errorFlag,
  });

  @override
  _ZTSStreamButtonState createState() => _ZTSStreamButtonState();
}

class _ZTSStreamButtonState extends State<ZTSStreamButton> {
  String error = "";

  @override
  Widget build(BuildContext context) {
    log(" flag ${widget.errorFlag}");
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            StreamBuilder<List<String>>(
                stream: widget.formValidationStream,
                builder: (context, snapshot) {
                  log(' snapshot ${snapshot.hasData.toString()}');

                  return Column(
                    children: [
                      SizedBox(
                        width: widget.width,
                        child: SizedBox(
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.text,
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                                onSurface: Theme.of(context).colorScheme.onPrimary,
                                elevation: snapshot.hasError || !snapshot.hasData ? 0 : 5),
                            onPressed: snapshot.hasError || !snapshot.hasData
                                ? () {
                                    setState(() {
                                      error = 'Fill all Fields to Login';
                                    });
                                  }
                                : () {
                                    setState(() {
                                      error = '';
                                    });
                                    widget.submit();
                                  },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      error != ""
                          ? Row(
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Theme.of(context).errorColor,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  error,
                                  style: TextStyle(color: Theme.of(context).errorColor),
                                ),
                              ],
                            )
                          : Container(),
                      widget.errorFlag && error == ""
                          ? Row(
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Theme.of(context).errorColor,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  widget.errrorText,
                                  style: TextStyle(color: Theme.of(context).errorColor),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  );
                }),
          ],
        ));
  }
}
