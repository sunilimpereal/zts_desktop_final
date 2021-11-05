// To parse this JSON data, do
//
//     final ticket = ticketFromJson(jsonString);

import 'dart:convert';

List<Ticket> ticketFromJson(String str) =>
    List<Ticket>.from(json.decode(str).map((x) => Ticket.fromJson(x)));

String ticketToJson(List<Ticket> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ticket {
  Ticket({
    required this.number,
    required this.lineitems,
    required this.price,
    required this.issuedTs,
  });

  String number;
  List<Lineitem> lineitems;
  double price;
  DateTime issuedTs;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        number: json['number'],
        lineitems: List<Lineitem>.from(json['lineitems'].map((x) => Lineitem.fromJson(x))),
        price: json['price'],
        issuedTs: DateTime.parse(json['issued_ts']),
      );

  Map<String, dynamic> toJson() => {
        'number': number,
        'lineitems': List<dynamic>.from(lineitems.map((x) => x.toJson())),
        'price': price,
        'issued_ts': issuedTs.toIso8601String(),
      };
}

class Lineitem {
  Lineitem({
    required this.subcategoryName,
    required this.type,
    required this.subcategoryPrice,
    required this.category,
    required this.quantity,
    required this.price,
    required this.createdTs,
  });

  String subcategoryName;
  String type;
  double subcategoryPrice;
  String category;
  int quantity;
  double price;
  DateTime createdTs;

  factory Lineitem.fromJson(Map<String, dynamic> json) => Lineitem(
        subcategoryName: json['subcategory_name'],
        type: json['type'],
        subcategoryPrice: json['subcategory_price'],
        category: json['category'],
        quantity: json['quantity'],
        price: json['price'],
        createdTs: DateTime.parse(json['created_ts']),
      );

  Map<String, dynamic> toJson() => {
        'subcategory_name': subcategoryName,
        'type': type,
        'subcategory_price': subcategoryPrice,
        'category': category,
        'quantity': quantity,
        'price': price,
        'created_ts': createdTs.toIso8601String(),
      };
}
