import 'package:flutter/material.dart';

import '../../../main.dart';

class ZTSTextField extends StatefulWidget {
  Function onTap;
  FocusNode focusNode;
  Stream<Object> stream;
  Function(String) onChanged;
  String labelText;
  IconData icon;
  TextEditingController controller;

  /// text field
  /// errror from stream
  final String? error;

  /// if has focus to highlight with border and elevation
  /// example :
  ///  onfocus: focusNode.hasfocus
  final bool onfocus;

  ///width of the text field
  final double width;

  ///heding on the textfield
  String heading;

  bool obscureText;

  ZTSTextField({
    Key? key,
    required this.onfocus,
    this.error,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    required this.labelText,
    required this.onChanged,
    required this.icon,
    required this.stream,
    required this.width,
    required this.heading,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _ZTSTextFieldState createState() => _ZTSTextFieldState();
}

class _ZTSTextFieldState extends State<ZTSTextField> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.stream,
        builder: (context, snapshot) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
              child: SizedBox(
                width: widget.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            widget.heading,
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            width: 2,
                            color: widget.onfocus
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent),
                      ),
                      child: Material(
                        elevation: widget.onfocus ? 0 : 0,
                        color: Theme.of(context).colorScheme.background,
                        shape: appStyles.shapeBorder(5),
                        shadowColor: Colors.grey[100],
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.7,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: widget.controller,
                            focusNode: widget.focusNode,
                            textAlign: TextAlign.left,
                            obscureText: widget.obscureText,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).textTheme.headline1!.color,
                              // AppConfig(context).width<1000?16: 18,
                              // fontFamily: appFonts.notoSans,//TODO: fonts
                              fontWeight: FontWeight.w600,
                            ),
                            onTap: () {
                              widget.onTap();
                            },
                            onChanged: widget.onChanged,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              // errorText: "${snapshot.error}",
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 10),
                              hintText: widget.labelText,
                              prefixIconConstraints:
                                  const BoxConstraints(minWidth: 23, maxHeight: 20),

                              isDense: false,
                              hintStyle: TextStyle(
                                  color: Theme.of(context).textTheme.headline1!.color,
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
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            snapshot.error != null
                                ? Text(
                                    snapshot.error.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).errorColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  )
                                : Container(),
                          ],
                        ))
                  ],
                ),
              ));
        });
  }
}
