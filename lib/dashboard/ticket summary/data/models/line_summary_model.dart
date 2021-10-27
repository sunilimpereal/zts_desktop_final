// To parse this JSON data, do
//
//     final lineSumryItem = lineSumryItemFromJson(jsonString);

import 'dart:convert';

List<LineSumryItem> lineSumryItemFromJson(String str) =>
    List<LineSumryItem>.from(json.decode(str).map((x) => LineSumryItem.fromJson(x)));

String lineSumryItemToJson(List<LineSumryItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LineSumryItem {
  LineSumryItem({
    required this.type,
    required this.subcategory,
    required this.subcategoryPrice,
    required this.category,
    required this.count,
    required this.lineitemPrice,
  });

  String type;
  String subcategory;
  double subcategoryPrice;
  String category;
  int count;
  double lineitemPrice;

  factory LineSumryItem.fromJson(Map<String, dynamic> json) => LineSumryItem(
        type: json['type'],
        subcategory: json['subcategory'],
        subcategoryPrice: json['subcategory_price'],
        category: json['category'],
        count: json['count'],
        lineitemPrice: json['lineitem_price'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'subcategory': subcategory,
        'subcategory_price': subcategoryPrice,
        'category': category,
        'count': count,
        'lineitem_price': lineitemPrice,
      };
}
