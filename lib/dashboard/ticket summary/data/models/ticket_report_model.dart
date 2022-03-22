// To parse this JSON data, do
//
//     final ticketReportItem = ticketReportItemFromJson(jsonString);

import 'dart:convert';

import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket.dart';

List<TicketReportItem> ticketReportItemFromJson(String str) =>
    List<TicketReportItem>.from(json.decode(str).map((x) => TicketReportItem.fromJson(x)));

String ticketReportItemToJson(List<TicketReportItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketReportItem {
  TicketReportItem({
    required this.id,
    required this.number,
    required this.organization,
    required this.userEmail,
    required this.organizationName,
    required this.lineitems,
    required this.price,
    required this.qrCode,
    required this.issuedTs,
    required this.onlineBooking,
    required this.isScanned,
    required this.createdTs,
    required this.modifiedTs,
    required this.fine,
  });

  int id;
  String number;
  int organization;
  String userEmail;
  String organizationName;
  List<Lineitem> lineitems;
  double price;
  QrCode qrCode;
  DateTime issuedTs;
  bool onlineBooking;
  bool isScanned;
  DateTime createdTs;
  DateTime modifiedTs;
  double fine;

  factory TicketReportItem.fromJson(Map<String, dynamic> json) => TicketReportItem(
        id: json['id'],
        number: json['number'],
        fine: json['fine'],
        organization: json['organization'],
        userEmail: json['user_email'],
        organizationName: json['organization_name'],
        lineitems: List<Lineitem>.from(json['lineitems'].map((x) => Lineitem.fromJson(x))),
        price: json['price'],
        qrCode: QrCode.fromJson(json['qr_code']),
        issuedTs: DateTime.parse(json['issued_ts']),
        onlineBooking: json['online_booking'],
        isScanned: json['isScanned'],
        createdTs: DateTime.parse(json['created_ts']),
        modifiedTs: DateTime.parse(json['modified_ts']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'organization': organization,
        'user_email': userEmail,
        'organization_name': organizationName,
        'lineitems': List<dynamic>.from(lineitems.map((x) => x.toJson())),
        'price': price,
        'qr_code': qrCode.toJson(),
        'issued_ts': issuedTs.toIso8601String(),
        'online_booking': onlineBooking,
        'isScanned': isScanned,
        'created_ts': createdTs.toIso8601String(),
        'modified_ts': modifiedTs.toIso8601String(),
      };
}

class QrCode {
  QrCode({
    required this.id,
    required this.isScanned,
    required this.online,
    required this.uuid,
    required this.createdTs,
    required this.modifiedTs,
  });

  int id;
  bool isScanned;
  bool online;
  String uuid;
  DateTime createdTs;
  DateTime modifiedTs;

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
        id: json['id'],
        isScanned: json['is_scanned'],
        online: json['online'],
        uuid: json['uuid'],
        createdTs: DateTime.parse(json['created_ts']),
        modifiedTs: DateTime.parse(json['modified_ts']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_scanned': isScanned,
        'online': online,
        'uuid': uuid,
        'created_ts': createdTs.toIso8601String(),
        'modified_ts': modifiedTs.toIso8601String(),
      };
}
