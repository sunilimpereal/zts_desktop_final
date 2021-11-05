// To parse this JSON data, do
//
//     final postTicketResponse = postTicketResponseFromJson(jsonString);

import 'dart:convert';

import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket.dart';

List<PostTicketResponse> postTicketResponseFromJson(String str) => List<PostTicketResponse>.from(json.decode(str).map((x) => PostTicketResponse.fromJson(x)));

String postTicketResponseToJson(List<PostTicketResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostTicketResponse {
    PostTicketResponse({
       required this.id,
       required this.number,
       required this.organization,
       required this.userEmail,
       required this.organizationName,
       required this.lineitems,
       required this.price,
       required this.issuedTs,
       required this.onlineBooking,
       required this.isScanned,
       required this.createdTs,
       required this.modifiedTs,
       required this.uuid,
    });

    int id;
    String number;
    int organization;
    String userEmail;
    String organizationName;
    List<Lineitem> lineitems;
    double price;
    DateTime issuedTs;
    bool onlineBooking;
    bool isScanned;
    DateTime createdTs;
    DateTime modifiedTs;
    String uuid;

    factory PostTicketResponse.fromJson(Map<String, dynamic> json) => PostTicketResponse(
        id: json["id"],
        number: json["number"],
        organization: json["organization"],
        userEmail: json["user_email"],
        organizationName: json["organization_name"],
        lineitems: List<Lineitem>.from(json["lineitems"].map((x) => Lineitem.fromJson(x))),
        price: json["price"],
        issuedTs: DateTime.parse(json["issued_ts"]),
        onlineBooking: json["online_booking"],
        isScanned: json["isScanned"],
        createdTs: DateTime.parse(json["created_ts"]),
        modifiedTs: DateTime.parse(json["modified_ts"]),
        uuid: json["uuid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "organization": organization,
        "user_email": userEmail,
        "organization_name": organizationName,
        "lineitems": List<dynamic>.from(lineitems.map((x) => x.toJson())),
        "price": price,
        "issued_ts": issuedTs.toIso8601String(),
        "online_booking": onlineBooking,
        "isScanned": isScanned,
        "created_ts": createdTs.toIso8601String(),
        "modified_ts": modifiedTs.toIso8601String(),
        "uuid": uuid,
    };
}

