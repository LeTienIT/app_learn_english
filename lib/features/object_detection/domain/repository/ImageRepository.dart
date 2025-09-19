import 'dart:io';

abstract class ImageRepository {
  Future<File?> pickAndCropImage();
}