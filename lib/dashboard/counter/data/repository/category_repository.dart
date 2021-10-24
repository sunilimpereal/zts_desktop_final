import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/repository/repositry.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategory() async {
    final response = await API.get(url: 'category/');
    if (response.statusCode == 200) {
      List<CategoryModel> categoryList = categoryModelFromJson(response.body);
      return categoryList;
    } else {
      return [];
    }
  }
}
