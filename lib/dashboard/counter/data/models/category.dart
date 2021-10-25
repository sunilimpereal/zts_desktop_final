// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.organization,
    required this.subcategories,
    required this.createdTs,
    required this.modifiedTs,
  });

  int id;
  String name;
  int organization;
  List<Subcategory> subcategories;
  DateTime createdTs;
  DateTime modifiedTs;
  int categoryPrice = 0;
  int categoryQyantity = 0;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        organization: json['organization'],
        subcategories:
            List<Subcategory>.from(json['subcategories'].map((x) => Subcategory.fromJson(x))),
        createdTs: DateTime.parse(json['created_ts']),
        modifiedTs: DateTime.parse(json['modified_ts']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'organization': organization,
        'subcategories': List<dynamic>.from(subcategories.map((x) => x.toJson())),
        'created_ts': createdTs.toIso8601String(),
        'modified_ts': modifiedTs.toIso8601String(),
      };
}

class Subcategory {
  Subcategory({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.category,
    required this.createdTs,
    required this.modifiedTs,
  });

  int id;
  String name;
  String type;
  double price;
  int category;
  DateTime createdTs;
  DateTime modifiedTs;
  int subCategoryTotalPrice =0;
  int quantity=0;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        price: json['price'],
        category: json['category'],
        createdTs: DateTime.parse(json['created_ts']),
        modifiedTs: DateTime.parse(json['modified_ts']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'price': price,
        'category': category,
        'created_ts': createdTs.toIso8601String(),
        'modified_ts': modifiedTs.toIso8601String(),
      };
}
