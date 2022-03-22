import 'dart:developer';
import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_bloc.dart';
import 'package:zts_counter_desktop/authentication/login/widgets/button.dart';
import 'package:zts_counter_desktop/authentication/login/widgets/text_field.dart';
import 'package:zts_counter_desktop/dashboard/settings/widgets/logo_selector.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController baseUrlController = TextEditingController();
  FocusNode baseUrlFocus = FocusNode();
  TextEditingController ticketNumController = TextEditingController();
  FocusNode tickNumFocus = FocusNode();
  TextEditingController bottleCodeController = TextEditingController();
  FocusNode bottleCodeFocus = FocusNode();
  TextEditingController seqStartController = TextEditingController();
  FocusNode seqStartFocus = FocusNode();
  TextEditingController seqEndController = TextEditingController();
  FocusNode seqEndFocus = FocusNode();

  @override
  void initState() {
    baseUrlController.text = sharedPrefs.getbaseUrl;
    ticketNumController.text = sharedPrefs.getTicketCode;
    bottleCodeController.text = sharedPrefs.getbottleCode;
    seqStartController.text = sharedPrefs.getbottleStart;
    seqEndController.text = sharedPrefs.getbottleEnd;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc? loginBloc = LoginProvider.of(context);
    loginBloc!.changebaseUrl(baseUrlController.text);
    loginBloc.changeticketCode(ticketNumController.text);
    return Container(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.94,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 15),
                  baseUrl(loginBloc),
                  ticketNumberCode(loginBloc),
                  TicketLogoSelector(),
                  SizedBox(
                    height: 16,
                  ),
                  bottleBarCodes(loginBloc, context),
                  SizedBox(
                    height: 0,
                  ),
                  saveButton(loginBloc)
                ],
              ),
            ),
          ),
        ),
      
    );
  }

  Widget baseUrl(LoginBloc? loginBloc) {
    return Container(
      child: Column(
        children: [
          ZTSTextField(
            width: 400,
            controller: baseUrlController,
            focusNode: baseUrlFocus,
            icon: Icons.email,
            labelText: 'Base Url',
            onChanged: (String value) {
              loginBloc!.changebaseUrl(value);
            },
            onfocus: baseUrlFocus.hasFocus,
            onTap: () {
              setState(() {});
            },
            stream: loginBloc!.baseUrl,
            heading: 'Base Url',
          ),
        ],
      ),
    );
  }

  Widget ticketNumberCode(LoginBloc? loginBloc) {
    return Container(
      child: Column(
        children: [
          ZTSTextField(
            width: 400,
            controller: ticketNumController,
            focusNode: tickNumFocus,
            icon: Icons.email,
            labelText: 'Ticket Number Code',
            onChanged: (String value) {
              loginBloc!.changeticketCode(value);
            },
            onfocus: tickNumFocus.hasFocus,
            onTap: () {
              setState(() {});
            },
            stream: loginBloc!.ticketCode,
            heading: 'Ticket Number Code',
          ),
        ],
      ),
    );
  }

  Widget bottleBarCodes(LoginBloc? loginBloc, BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "Bottle Barcode",
            style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18),
          ),
        ),
        //code
        ZTSTextField(
          width: 400,
          controller: bottleCodeController,
          focusNode: bottleCodeFocus,
          icon: Icons.email,
          labelText: 'Code',
          onChanged: (String value) {
            loginBloc!.changebottleCode(value);
          },
          onfocus: bottleCodeFocus.hasFocus,
          onTap: () {
            setState(() {});
          },
          stream: loginBloc!.bottleCode,
          heading: 'Bottle Sequence Code',
        ),
        ZTSTextField(
          width: 400,
          controller: seqStartController,
          focusNode: seqStartFocus,
          icon: Icons.email,
          labelText: 'Sequence Start',
          onChanged: (String value) {
            loginBloc.changeSeqStart(value);
          },
          onfocus: seqStartFocus.hasFocus,
          onTap: () {
            setState(() {});
          },
          stream: loginBloc.seqStart,
          heading: 'Start',
        ),
        ZTSTextField(
          width: 400,
          controller: seqEndController,
          focusNode: seqEndFocus,
          icon: Icons.email,
          labelText: 'Sequence End',
          onChanged: (String value) {
            loginBloc.changeSeqEnd(value);
          },
          onfocus: seqEndFocus.hasFocus,
          onTap: () {
            setState(() {});
          },
          stream: loginBloc.seqEnd,
          heading: 'End',
        ),
      ],
    ));
  }

  Widget saveButton(LoginBloc? loginBloc) {
    return Container(
      child: Row(
        children: [
          ZTSStreamButton(
              width: 150,
              formValidationStream: loginBloc!.validateSettingsFormStream,
              submit: () {
                sharedPrefs.setbaseUrl(baseUrl: baseUrlController.text);
                sharedPrefs.setTicketCode(baseUrl: ticketNumController.text);
                sharedPrefs.setBarCode(
                  bottleCode: bottleCodeController.text,
                  start: seqStartController.text,
                  end: seqEndController.text,
                );
              },
              text: 'Save',
              errrorText: '',
              errorFlag: false)
        ],
      ),
    );
  }
}
