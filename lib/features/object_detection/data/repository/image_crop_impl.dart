import 'dart:io';

import '../../../../services/image/ImageService.dart';
import '../../domain/repository/ImageRepository.dart';

class ImageImpl implements ImageRepository{
  final ImageService imageService;

  ImageImpl(this.imageService);

  @override
  Future<File?> pickAndCropImage() async{
    return await imageService.pickAndCropImage();
  }

}