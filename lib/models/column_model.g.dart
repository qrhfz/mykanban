// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColumnModelAdapter extends TypeAdapter<ColumnModel> {
  @override
  final int typeId = 1;

  @override
  ColumnModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColumnModel(
      fields[0] as String,
      tasks: (fields[1] as List).cast<TaskModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ColumnModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.columnName)
      ..writeByte(1)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
