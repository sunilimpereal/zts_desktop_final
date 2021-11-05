import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/category.dart';
import 'package:zts_counter_desktop/dashboard/counter/data/models/post_ticekt_response.dart';
import 'package:zts_counter_desktop/dashboard/ticket%20summary/data/models/ticket.dart';
import 'package:zts_counter_desktop/dashboard/counter/widgets/sub_category_card.dart';
import 'package:zts_counter_desktop/main.dart';
import 'package:zts_counter_desktop/printer/bill_pdf.dart';
import 'package:zts_counter_desktop/printer/parking_bill.dart';
import 'package:zts_counter_desktop/repository/repositry.dart';
import 'package:zts_counter_desktop/utils/methods.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

class CategoryRepository {

  Future<List<CategoryModel>> getCategory(BuildContext context) async {
         Map<String, String>? headers = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPref.token}',
  };
    final response = await API.get(url: 'category/', context: context,headers1: headers);
    if (response.statusCode == 200) {
      List<CategoryModel> categoryList = categoryModelFromJson(response.body);
      return categoryList;
    } else {
      return [];
    }
  }

  Future<bool> generateTicket({
    required BuildContext context,
    required CategoryModel category,
  }) async {
    Ticket ticket = getTicket([category]);
    final response =
        await API.post(url: 'ticket/', context: context, body: ticketToJson([ticket]), logs: true);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<PostTicketResponse> ticketResponse = postTicketResponseFromJson(response.body);
      if (getRole() == "mys-parking") {
        final pdfFile = await ParkingPdf.parkingBill(
            ticketNumber: ticket.number,
            dateTime: ticket.issuedTs,
            qrImage: await toQrImageData(ticketResponse[0].uuid),
            total: getTotalCategory([category]),
            listCategory: [category]);

        final pdf = pdfFile.readAsBytes();
        List<Printer> printerList = await Printing.listPrinters();
        sharedPref.getPrinter.length > 2
            ? await Printing.directPrintPdf(
                printer:
                    printerList.firstWhere((element) => element.name == sharedPrefs.getPrinter),
                onLayout: (_) => pdf)
            : await Printing.layoutPdf(onLayout: (_) => pdf);
        String path = await createFolderInAppDocDir("bills");
        PdfApi.openFile(pdfFile.renameSync("$path/${ticket.number}.pdf"));
        return true;
      }
      if (category.name == "Locker") {
        log("locker");
        final pdfFile = await PdfApi.zooBill(
            listCategory: [category],
            ticketNumber: ticket.number,
            dateTime: ticket.issuedTs,
            total: getTotalCategory([category]),
            image: await toQrImageData(ticketResponse[0].uuid));
        final pdf = pdfFile.readAsBytes();
        List<Printer> printerList = await Printing.listPrinters();
        sharedPref.getPrinter.length > 2
            ? await Printing.directPrintPdf(
                printer:
                    printerList.firstWhere((element) => element.name == sharedPrefs.getPrinter),
                onLayout: (_) => pdf)
            : await Printing.layoutPdf(onLayout: (_) => pdf);
        sharedPref.getPrinter.length > 2
            ? await Printing.directPrintPdf(
                printer:
                    printerList.firstWhere((element) => element.name == sharedPrefs.getPrinter),
                onLayout: (_) => pdf)
            : await Printing.layoutPdf(onLayout: (_) => pdf);
        String path = await createFolderInAppDocDir("bills");
        PdfApi.openFile(pdfFile.renameSync("$path/${ticket.number}.pdf"));
        return true;
      }

      final pdfFile = await PdfApi.zooBill(
          listCategory: [category],
          ticketNumber: ticket.number,
          dateTime: ticket.issuedTs,
          total: getTotalCategory([category]),
          image: await toQrImageData(ticketResponse[0].uuid));
      final pdf = pdfFile.readAsBytes();
      List<Printer> printerList = await Printing.listPrinters();
      sharedPref.getPrinter.length > 2
          ? await Printing.directPrintPdf(
              printer: printerList.firstWhere((element) => element.name == sharedPrefs.getPrinter),
              onLayout: (_) => pdf)
          : await Printing.layoutPdf(onLayout: (_) => pdf);
      String path = await createFolderInAppDocDir("bills");
      PdfApi.openFile(pdfFile.renameSync("$path/${ticket.number}.pdf"));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> bottleScan({required BuildContext context, required String barcode}) async {
    //  final response =
    //     await API.post(url: 'ticket/', context: context, body: ticketToJson([ticket]), logs: true);
    bool a = await Future.delayed(const Duration(seconds: 1)).then((value) {
      if (barcode == '11111') {
        return true;
      } else {
        return false;
      }
    });

    return a;
  }
}
