import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ViewPhoto extends StatelessWidget {
  String photoUrl;

  ViewPhoto(this.photoUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: downloadImage, icon: const Icon(Icons.download))
        ],
      ),
      body: Dismissible(
        background: Container(
          color: Colors.black,
        ),
        key: const Key('key'),
        direction: DismissDirection.down,
        onDismissed: (_) => Navigator.pop(context),
        child: PhotoView(
          imageProvider: NetworkImage(photoUrl),
          loadingBuilder: (_, __) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (_, __, ___) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void saveImage(File file) async {
    EasyLoading.show(status: "saving...");

    if (await Permission.storage.request().isGranted) {
      Directory? dir = await getExternalStorageDirectory();
      String newPath = "";
      List<String> folders = dir!.path.split("/");
      for (int x = 1; x < folders.length; x++) {
        if (folders[x] != 'Android') {
          newPath += "/" + folders[x];
        } else {
          break;
        }
      }
      newPath = newPath + "/Pharmacy APP";
      dir = Directory(newPath);
      if (await dir.exists()) {
        file.copy(newPath + "/${DateTime.now()}.jpeg").then((value) {
          EasyLoading.showInfo("file saved in Pharmacy APP file ");
        }).catchError((err) {
          EasyLoading.showError("an error Happened while saving");
        });
      } else {
        Directory(newPath).create().then((value) {
          file.copy(newPath + "/${DateTime.now()}.jpeg");
          EasyLoading.showInfo("file saved in Pharmacy APP file ");
        }).catchError((err) {
          EasyLoading.showError("an error Happened while saving");
        });
      }
    } else {
      EasyLoading.showError("Permission refused");
    }
  }

  Future<void> downloadImage() async {
    EasyLoading.show(status: "downloading...");

    await FirebaseStorage.instance
        .refFromURL(photoUrl)
        .getData()
        .then((value) async {
      if (value != null) {
        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/image.jpeg').create();
        file.writeAsBytesSync(value);
        saveImage(file);
      } else {
        EasyLoading.showError("Error happened while downloading the photo");
      }
    }).catchError((err) {
      EasyLoading.showError("Error happened while downloading the photo");
    });
  }
}
