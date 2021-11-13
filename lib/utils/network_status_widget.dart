import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zts_counter_desktop/utils/methods.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({Key? key}) : super(key: key);

  @override
  _NetworkStatusWidgetState createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  @override
  void initState() {
    updateTime();
    super.initState();
  }

  updateTime() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      hasNetwork().then((value) {
        try{
        setState(() {
          networkStatus = value;
        });
        }catch(e){

        }
      });
     
    });
  }



  bool networkStatus = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text( DateFormat().add_Hm().addPattern(" ").add_yMEd().format(DateTime.now())),
            ],
          ),
        ),
        SizedBox(width: 24,),
        Container(
          height: 45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon( networkStatus?Icons.network_wifi:Icons.wifi_off ,color: networkStatus?Colors.green:Colors.red,),
              const SizedBox(width: 8),
              Text( networkStatus? 'Online':'Offline'),
            ],
          ),
        ),
      ],
    );
  }

}
