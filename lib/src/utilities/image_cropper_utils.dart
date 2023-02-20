import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:interpretasi_editor/src/common/colors.dart';

class ImageCropperUtils {
  static Future<CroppedFile?> cropImage(
    BuildContext context, {
    required String filePath,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 4),
      cropStyle: cropStyle,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: ColorLight.background,
          hideBottomControls: true,
          activeControlsWidgetColor: ColorLight.card,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          toolbarTitle: 'Crop',
        ),
        WebUiSettings(
          context: context,
          enableZoom: true,
          showZoomer: true,
          boundary: const CroppieBoundary(
            width: 400,
            height: 225,
          ),
          viewPort: const CroppieViewPort(
            width: 444,
            height: 250,
          ),
        ),
      ],
    );
    return croppedImage;
  }
}
