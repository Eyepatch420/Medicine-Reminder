import 'package:uuid/uuid.dart';
import '../core/errors/storage_exception.dart';
import '../core/models/medicine.dart';
import '../core/utils/validators.dart';
import '../data/hive_service.dart';
import '../data/alarm_service.dart';

class MedicineService {
  final HiveService _hiveService;
  final Uuid _uuid = const Uuid();

  MedicineService(this._hiveService);

  List<Medicine> getAllMedicines() {
    try {
      return _hiveService.getMedicines();
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException('Failed to retrieve medicines', originalError: e);
    }
  }

  Future<Medicine> addMedicine(
      String name,
      String dosage,
      int hour,
      int minute,
      ) async {
    Validators.validateMedicineName(name);
    Validators.validateDosage(dosage);
    Validators.validateTime(hour, minute);

    final id = _uuid.v4();

    final medicine = Medicine(
      id: id,
      name: name.trim(),
      dosage: dosage.trim(),
      hour: hour,
      minute: minute,
      isActive: true,
      createdAt: DateTime.now(),
    );

    _hiveService.addMedicine(medicine);

    await AlarmService.scheduleDailyAlarm(medicine);

    return medicine;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    Validators.validateMedicineName(medicine.name);
    Validators.validateDosage(medicine.dosage);
    Validators.validateTime(medicine.hour, medicine.minute);

    _hiveService.updateMedicine(medicine);

    await AlarmService.cancelAlarm(medicine.id);

    if (medicine.isActive) {
      await AlarmService.scheduleDailyAlarm(medicine);
    }
  }

  Future<void> deleteMedicine(String id) async {
    _hiveService.deleteMedicine(id);
    await AlarmService.cancelAlarm(id);
  }

  Future<Medicine> toggleMedicineActive(String id) async {
    Medicine medicine = _hiveService.getMedicineById(id);
    final updated = medicine.copyWith(isActive: !medicine.isActive);

    await updateMedicine(updated);
    return updated;
  }
}
