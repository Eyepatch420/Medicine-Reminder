import '../errors/validation_exception.dart';

class Validators {
  static void validateMedicineName(String? name) {
    if (name == null || name.trim().isEmpty) {
      throw ValidationException('Medicine name cannot be empty', field: 'name');
    }
    if (name.trim().length > 50) {
      throw ValidationException('Medicine name cannot exceed 50 characters', field: 'name');
    }
  }

  static void validateDosage(String? dosage) {
    if (dosage == null || dosage.trim().isEmpty) {
      throw ValidationException('Dosage cannot be empty', field: 'dosage');
    }
    if (dosage.trim().length > 30) {
      throw ValidationException('Dosage cannot exceed 30 characters', field: 'dosage');
    }
  }

  static void validateHour(int hour) {
    if (hour < 0 || hour > 23) {
      throw ValidationException('Hour must be between 0 and 23', field: 'hour');
    }
  }

  static void validateMinute(int minute) {
    if (minute < 0 || minute > 59) {
      throw ValidationException('Minute must be between 0 and 59', field: 'minute');
    }
  }

  static void validateTime(int hour, int minute) {
    validateHour(hour);
    validateMinute(minute);
  }
}
