import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:formc_showcase/models/ApplicationImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';

class Utility {
  _cropImage(imageFile) async {
    // print('Image inside crop $imageFile');
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      maxWidth: 600,
      maxHeight: 1200,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square
              //CropAspectRatioPreset.ratio3x2,
              //CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              // CropAspectRatioPreset.ratio16x9
            ]
          : [
              //CropAspectRatioPreset.original,
              CropAspectRatioPreset.square
              // CropAspectRatioPreset.ratio3x2,
              // CropAspectRatioPreset.ratio4x3,
              // CropAspectRatioPreset.ratio5x3,
              //  CropAspectRatioPreset.ratio5x4,
              //  CropAspectRatioPreset.ratio7x5,
              //  CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Edit Photo',
            toolbarColor: blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Edit Photo',
          aspectRatioLockEnabled: false,
        )
      ],
    );
    // print('Cropped file $croppedFile');
    return croppedFile;
  }

  File? _image;
  final _picker = ImagePicker();
  Future<ApplicantImage> getImage(ImageSource imageSource) async {
    PickedFile? image;
    File? file;
    String? base64Image;
    double size = 0.0;
    switch (imageSource) {
      case ImageSource.camera:
        try {
          image =
              await ImagePicker.platform.pickImage(source: ImageSource.camera);
          //print(image);
          if (image != null) {
            file = File(image.path);
            final Directory directory =
                await getApplicationDocumentsDirectory();
            final path = directory.path;
            final String fileName = basename(image.path);
// final String fileExtension = extension(image.path);
            File newImage = await file.copy('$path/$fileName');
            _image = newImage;
            // print('image $_image');
          }
          if (_image != null) {
            // print('Image inside cam $image');
            // print('/////////////');
            _image = await _cropImage(file);
            // print('************');
            // print('Image inside cam after crop $_image');

            size = double.parse(
                (File(_image!.path).lengthSync() / 1024).toStringAsFixed(2));

            base64Image = base64Encode(File(_image!.path).readAsBytesSync());
          }
          //print('image size: $size');
        } catch (e) {
          // print('error Inside catch of camera $e');
          _showPermissionDialog(
              "Permission", 'Allow app to access the Camera.');
        }
        break;
      case ImageSource.gallery:
        //print('gallery');
        try {
          image =
              await ImagePicker.platform.pickImage(source: ImageSource.gallery);
          //print(image);
          if (image != null) {
            file = File(image.path);
            final Directory directory =
                await getApplicationDocumentsDirectory();
            final path = directory.path;
            final String fileName = basename(image.path);
// final String fileExtension = extension(image.path);
            File newImage = await file.copy('$path/$fileName');
            _image = newImage;
            // print('image $_image');
          }
          if (_image != null) {
            _image = await _cropImage(File(_image!.path));
            size = double.parse(
                (File(_image!.path).lengthSync() / 1024).toStringAsFixed(2));
            base64Image = base64Encode(File(_image!.path).readAsBytesSync());
            final fileName = p.basename(_image!.path);
            //print(fileName);
            String imageFileName = fileName;
            var fileExtn = p.extension(imageFileName);
            fileExtn = fileExtn.toLowerCase();
            int idx = imageFileName.indexOf(".");
            fileExtn = imageFileName.substring(idx + 1).trim();
            fileExtn = fileExtn.toLowerCase();
            // print('extn $fileExtn');
          }

          //print('image size: $size');
        } catch (e) {
          //print(e);
          // print('error $e');
          _showPermissionDialog("Permission",
              'Allow app to access photos, media and files on your device?');
        }
        break;
    }
    return ApplicantImage(photo: base64Image, size: size);
  }
//

  static displaySnackBar(GlobalKey<ScaffoldState> globalkey, String content) {
    final snackBar = SnackBar(
      content: Text(content),
    );
    // globalkey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
  }

  Future<void> _showPermissionDialog(String title, String message) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings();
              },
              child: Text("Go to Settings"),
            ),
          ],
        );
      },
    );
  }
}
