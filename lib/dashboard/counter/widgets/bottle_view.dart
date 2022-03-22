import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository.dart';

import '../../../main.dart';

class BottleView extends StatefulWidget {
  final Color? color;
  final CategoryModel category;
  const BottleView({Key? key, required this.color, required this.category}) : super(key: key);

  @override
  _BottleViewState createState() => _BottleViewState();
}

class _BottleViewState extends State<BottleView> {
  late bool loading = false;
  late String barCode = "";
  final FocusNode _textNode = FocusNode();
  final TextEditingController _textController = new TextEditingController();
  clear() {
    setState(() {
      barCode = "";
      _textNode.requestFocus();
      _textController.text = "";
    });
  }

  int scannedResult = 0;

  @override
  Widget build(BuildContext context) {
    if (scannedResult != 0) {
      Future.delayed(Duration(seconds: 1, milliseconds: 500)).then((value) {
        setState(() {
          scannedResult = 0;
        });
      });
    }
    return Expanded(
        child: RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          log("enter Pressed");
           barcodeScan(context: context, barcode: _textController.text, clear: clear);
        } else if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
        } else {
          if (event.character != null || !event.isKeyPressed(LogicalKeyboardKey.enter)) {
            log("event : " + event.data.keyLabel);
             _textController.text = _textController.text + cleanBarCode( event.data.keyLabel); 
          }
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height - 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                tileMode: TileMode.clamp,
                colors: [
              widget.color!.withOpacity(0.2),
              Colors.white,
            ])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.name,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Scan Bottle',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(height: 24),
                      textfield(context),
                      const SizedBox(height: 24),
                      Container(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            barcodeScan(context: context, barcode: _textController.text, clear: clear);
                          },
                          child: const Text(
                            'Scan',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      scannedResult != 0 ? postScan() : Container()
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget textfield(BuildContext context) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
            width: 2,
            color: _textNode.hasFocus ? Theme.of(context).colorScheme.primary : Colors.transparent),
      ),
      child: Material(
        elevation: _textNode.hasFocus ? 0 : 0,
        color: Theme.of(context).colorScheme.background,
        shape: appStyles.shapeBorder(5),
        shadowColor: Colors.grey[100],
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.7,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.headline1!.color,
              // AppConfig(context).width<1000?16: 18,
              // fontFamily: appFonts.notoSans,//TODO: fonts
              fontWeight: FontWeight.w600,
            ),
            onTap: () {},
            readOnly: true,
            showCursor: false,
            controller: _textController,
            focusNode: _textNode,
            onChanged: (value) {
              log(' $value');
              setState(() {
                barCode = value;
              });
            },
            onFieldSubmitted: (value) async {
              barcodeScan(context: context, barcode: barCode.trim(), clear: clear);
            },
            decoration: InputDecoration(
              // errorText: "${snapshot.error}",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 10),
              prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
              isDense: false,
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  _textController.clear();
                });

              }, icon:const Icon( Icons.close)),
              hintStyle:
                  TextStyle(color: Theme.of(context).textTheme.headline1!.color, fontSize: 16),
              labelStyle: TextStyle(
                height: 0.6,
                fontSize: 16,
                color: Theme.of(context).textTheme.headline1!.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget postScan() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.3,
      color: scannedResult == 1 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
      child: Column(
        children: [
          Container(
            height: scannedResult != 1 ? 250 : null,
            width: scannedResult != 1 ? 300 : null,
            child: Container(
              child: Lottie.asset(
                scannedResult == 1 ? 'assets/lottie/successful.json' : 'assets/lottie/error.json',
                fit: BoxFit.cover,
                repeat: false,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          Text(
            scannedResult == 1 ? 'Bottle Scanned' : 'Invalid Barcode',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: scannedResult == 1 ? Theme.of(context).primaryColor : Colors.red,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(barCode),
        ],
      ),
    );
  }

  void barcodeScan(
      {required BuildContext context, required String barcode, required Function clear}) {
    setState(() {
      loading = true;
    });
    CategoryRepository categoryRepository = CategoryRepository();
    categoryRepository.bottleScan(context: context, barcode: barcode).then((value) {
      if (value) {
        setState(() {
          loading = false;
          scannedResult = 1;
          clear();
        });
      } else {
        setState(() {
          loading = false;
          scannedResult = 2;
          clear();
        });
      }
    });
  }
}


String cleanBarCode(String barcode){
  String newBarcode = barcode;
         newBarcode = newBarcode.replaceAll('!', '1');
         newBarcode = newBarcode.replaceAll('@', '2');
         newBarcode = newBarcode.replaceAll('#', '3');
         newBarcode = newBarcode.replaceAll('\$', '4');
         newBarcode = newBarcode.replaceAll('%', '5');
         newBarcode = newBarcode.replaceAll('^', '6');
         newBarcode = newBarcode.replaceAll('&', '7');
         newBarcode = newBarcode.replaceAll('*', '8');
         newBarcode = newBarcode.replaceAll('(', '9');
  newBarcode=newBarcode.replaceAll(')', '0');
  return newBarcode.toUpperCase();
}