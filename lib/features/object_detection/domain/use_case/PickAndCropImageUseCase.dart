import 'dart:io';

import '../repository/ImageRepository.dart';

class PickAndCropImageUseCase {
  final ImageRepository repository;

  PickAndCropImageUseCase(this.repository);

  Future<File?> call() => repository.pickAndCropImage();
}
