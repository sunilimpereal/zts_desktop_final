import 'dart:developer';
import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/main.dart';

class TicketLogoSelector extends StatefulWidget {
  const TicketLogoSelector({Key? key}) : super(key: key);

  @override
  _TicketLogoSelectorState createState() => _TicketLogoSelectorState();
}

class _TicketLogoSelectorState extends State<TicketLogoSelector> {
  @override
  Widget build(BuildContext context) {
    imageCache?.clear();
    File imgFile = File("assets/images/ticket_logo.png");
    String selectedFile = "";
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ticket Logo',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  // style: ElevatedButton.styleFrom(
                  //   primary: Colors.transparent,
                  //   elevation: 0,
                  //   onPrimary: Theme.of(context).textTheme.headline5!.color,
                  //   shadowColor: Colors.white
                  // ),

                  onPressed: () async {
                    final file = OpenFilePicker()
                      ..filterSpecification = {
                        'Image (*.png)': '*.png',
                        'Image (*.jpg)': '*.jpg',
                        'Image (*.jpeg)': '*.jpeg',
                      }
                      ..defaultFilterIndex = 0
                      ..defaultExtension = 'png'
                      ..title = 'Select ticket logo';

                    final File? result = file.getFile();
                    imageCache?.clearLiveImages();
                    imageCache?.clear();
                    if (result != null) {
                      print("picked path : ${result.path}");
                      saveImage(result.readAsBytesSync(), "ticket_logo.png").then((value) {
                        setState(() {
                          selectedFile = result.path;
                          imgFile = result;
                          log("changed");
                        });
                      });
                    }
                  },
                  child: Row(
                    children: const [
                      Text(
                        'Choose Image',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.edit,
                        size: 16,
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(width: 16),
          Container(
            width: 200,
            height: 100,
            child: imgFile.existsSync()
                ? Image.memory(
                    imgFile.readAsBytesSync(),
                    fit: BoxFit.contain,
                  )
                : Container(
                    child: Column(
                      children: const [Text('Select Image')],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Future saveImage(imageData, String imageName) async {
    // Future<String> getPicturesPath() async {
    //   Directory docDir = await getApplicationDocumentsDirectory();
    //   print("docDir path : ${docDir.path}");
    //   var pathList = docDir.path.split('\\');
    //   pathList[pathList.length - 1] = 'Pictures';
    //   var picturePath = pathList.join('\\');
    //   print(picturePath);
    //   return picturePath;
    // }

    // var picturesPath = await getPicturesPath();
    // var thetaImage =
    //     await File(join(picturesPath, 'theta_images', imageName)).create(recursive: true);
    File file = await File("assets/images/${imageName}").create(recursive: true);
    await file.writeAsBytes(imageData);
    return file;
  }
}
