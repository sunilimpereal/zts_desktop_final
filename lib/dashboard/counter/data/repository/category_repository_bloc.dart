import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/repository/category_repository.dart';
import 'package:zts_counter_desktop/utils/bloc.dart';

class CategoryBloc extends Bloc {
  CategoryBloc() {
    getCategoryList();
  }
  final StreamController<List<CategoryModel>> _controller = BehaviorSubject();
   CategoryModel? categoryModel;
  Stream<List<CategoryModel>> get categoryListStream => _controller.stream.asBroadcastStream();
  void getCategoryList() async {
    CategoryRepository _categoryRepository = CategoryRepository();
    final result = await _categoryRepository.getCategory();
    categoryModel =categoryModel ?? result[0];
    _controller.sink.add(result);
  }

  CategoryModel? getSelectedcategory() {
    return categoryModel??null;
  }

   updateSelectedCategory(CategoryModel categoryModellocal) {
    categoryModel = categoryModellocal;
    getCategoryList();
  }

  @override
  void dispose() {}
}

class CategoryProvider extends InheritedWidget {
  final bloc = CategoryBloc();
  CategoryProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CategoryBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CategoryProvider>() as CategoryProvider)
        .bloc;
  }
}
