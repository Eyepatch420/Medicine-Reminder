import 'package:hive/hive.dart';
import '../constants/app_constants.dart';

part 'medicine.g.dart';

@HiveType(typeId: AppConstants.medicineTypeId)
class Medicine extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String dosage;

  @HiveField(3)
  final int hour;

  @HiveField(4)
  final int minute;

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final DateTime createdAt;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.hour,
    required this.minute,
    required this.isActive,
    required this.createdAt,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? dosage,
    int? hour,
    int? minute,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medicine &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          dosage == other.dosage &&
          hour == other.hour &&
          minute == other.minute &&
          isActive == other.isActive &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      dosage.hashCode ^
      hour.hashCode ^
      minute.hashCode ^
      isActive.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'Medicine(id: $id, name: $name, dosage: $dosage, hour: $hour, minute: $minute, isActive: $isActive, createdAt: $createdAt)';
  }
}
