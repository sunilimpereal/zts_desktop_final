import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

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

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  bool networkStatus = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.circle,color: networkStatus?Colors.green:Colors.red,),
          const SizedBox(width: 8),
          Text( networkStatus? 'Online':'Offline'),
        ],
      ),
    );
  }

}
