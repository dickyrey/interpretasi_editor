import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:interpretasi_editor/src/common/enums.dart';

class ImageCropperUtils {
  static Future<CroppedFile?> cropImage(
    BuildContext context, {
    required String filePath,
    required DeviceType type,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    int boundaryWidth;
    int boundaryHeight;
    int viewPortWidth;
    int viewPortHeight;

    if (type == DeviceType.mobile) {
      boundaryWidth = 300;
      boundaryHeight = 168;
      viewPortWidth = 200;
      viewPortHeight = 112;
    } else if (type == DeviceType.desktop) {
      boundaryWidth = 500;
      boundaryHeight = 281;
      viewPortWidth = 400;
      viewPortHeight = 225;
    } else {
      boundaryWidth = 700;
      boundaryHeight = 393;
      viewPortWidth = 600;
      viewPortHeight = 337;
    }

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 4),
      cropStyle: cropStyle,
      uiSettings: [
        WebUiSettings(
          context: context,
          enableZoom: true,
          showZoomer: true,
          boundary: CroppieBoundary(
            width: boundaryWidth,
            height: boundaryHeight,
          ),
          viewPort: CroppieViewPort(
            width: viewPortWidth,
            height: viewPortHeight,
          ),
        ),
      ],
    );
    return croppedImage;
  }
}
