// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordDataAdapter extends TypeAdapter<WordData> {
  @override
  final int typeId = 0;

  @override
  WordData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordData(
      english: fields[0] as String,
      vietnamese: fields[1] as String,
      example: fields[2] as String?,
      favorite: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WordData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.english)
      ..writeByte(1)
      ..write(obj.vietnamese)
      ..writeByte(2)
      ..write(obj.example)
      ..writeByte(3)
      ..write(obj.favorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
