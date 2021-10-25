import 'package:flutter/cupertino.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/repository/repositry.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategory(BuildContext context) async {
    final response = await API.get(url: 'category/', context: context);
    if (response.statusCode == 200) {
      List<CategoryModel> categoryList = categoryModelFromJson(response.body);
      return categoryList;
    } else {
      return [];
    }
  }
}
