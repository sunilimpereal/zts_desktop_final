// To parse this JSON data, do
//
//     final generatedTickets = generatedTicketsFromJson(jsonString);

import 'dart:convert';

List<GeneratedTickets> generatedTicketsFromJson(String str) => List<GeneratedTickets>.from(json.decode(str).map((x) => GeneratedTickets.fromJson(x)));

String generatedTicketsToJson(List<GeneratedTickets> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeneratedTickets {
    GeneratedTickets({
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
    });

    int id;
    String number;
    int organization;
    String userEmail;
    String organizationName;
    List<GeneratedLineitem> lineitems;
    double price;
    DateTime issuedTs;
    bool onlineBooking;
    bool isScanned;
    DateTime createdTs;
    DateTime modifiedTs;

    factory GeneratedTickets.fromJson(Map<String, dynamic> json) => GeneratedTickets(
        id: json['id'],
        number: json['number'],
        organization: json['organization'],
        userEmail: json['user_email'],
        organizationName: json['organization_name'],
        lineitems: List<GeneratedLineitem>.from(json['lineitems'].map((x) => GeneratedLineitem.fromJson(x))),
        price: json['price'],
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
        'issued_ts': issuedTs.toIso8601String(),
        'online_booking': onlineBooking,
        'isScanned': isScanned,
        'created_ts': createdTs.toIso8601String(),
        'modified_ts': modifiedTs.toIso8601String(),
    };
}

class GeneratedLineitem {
    GeneratedLineitem({
      required  this.id,
      required  this.subcategoryName,
      required  this.type,
      required  this.subcategoryPrice,
      required  this.category,
      required  this.quantity,
      required  this.price,
      required  this.createdTs,
      required  this.modifiedTs,
    });

    int id;
    String subcategoryName;
    String type;
    double subcategoryPrice;
    String category;
    int quantity;
    double price;
    DateTime createdTs;
    DateTime modifiedTs;

    factory GeneratedLineitem.fromJson(Map<String, dynamic> json) => GeneratedLineitem(
        id: json['id'],
        subcategoryName: json['subcategory_name'],
        type: json['type'],
        subcategoryPrice: json['subcategory_price'],
        category: json['category'],
        quantity: json['quantity'],
        price: json['price'],
        createdTs: DateTime.parse(json['created_ts']),
        modifiedTs: DateTime.parse(json['modified_ts']),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'subcategory_name': subcategoryName,
        'type': type,
        'subcategory_price': subcategoryPrice,
        'category': category,
        'quantity': quantity,
        'price': price,
        'created_ts': createdTs.toIso8601String(),
        'modified_ts': modifiedTs.toIso8601String(),
    };
}

