import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/sub_category_card.dart';
import 'package:zts_counter_desktop/main.dart';
import 'package:zts_counter_desktop/repository/repositry.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

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

  Future<bool> generateTicket({
    required BuildContext context,
    required List<CategoryModel> list,
  }) async {
    final response =
        await API.post(url: 'ticket/', context: context, body: ticketToJson([getTicket(list)]));
    if (response.statusCode == 200||response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  getTicketNumber() {
    DateTime currentDateTime = DateTime.now();
    final parms = [
      'MYS',
      sharedPrefs.loginId,
      currentDateTime.month + 1,
      currentDateTime.day,
      currentDateTime.millisecond.toString().padLeft(3, '0')
    ];
    final ticketNumber = parms.join('');
    return ticketNumber;
  }

  Ticket getTicket(List<CategoryModel> list) {
    List<Lineitem> lineItemList = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].categoryQyantity != 0) {
        for (int si = 0; si < list[i].subcategories.length; si++) {
          if (list[i].subcategories[si].quantity != 0) {
            Subcategory subCat = list[i].subcategories[si];
            lineItemList.add(Lineitem(
              subcategoryName: subCat.name,
              type: subCat.type,
              subcategoryPrice: subCat.price.ceil(),
              category: list[i].name,
              quantity: subCat.quantity,
              price: subCat.quantity * subCat.price.ceil(),
              createdTs: DateTime.now(),
            ));
          }
        }
      }
    }
    return Ticket(
      number: getTicketNumber(),
      lineitems: lineItemList,
      price: getTotalCategory(list),
      issuedTs: DateTime.now(),
    );
  }

  getTotalCategory(List<CategoryModel> list) {
    int sum = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].categoryQyantity != 0) {
        for (int si = 0; si < list[i].subcategories.length; si++) {
          if (list[i].subcategories[si].quantity != 0) {
            sum =
                sum + (list[i].subcategories[si].quantity * list[i].subcategories[si].price).ceil();
          }
        }
      }
    }
    return sum;
  }
}
