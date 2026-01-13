import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/not_found_exception.dart';
import '../core/errors/storage_exception.dart';
import '../core/models/medicine.dart';

class HiveService {
  Box<Medicine> get _box {
    try {
      return Hive.box<Medicine>(AppConstants.medicinesBoxName);
    } catch (e) {
      throw StorageException('Failed to access medicine box', originalError: e);
    }
  }

  List<Medicine> getMedicines() {
    debugPrint('[Hive] getMedicines called');
    try {
      final list = _box.values.toList();
      debugPrint('[Hive] getMedicines returned ${list.length} items');
      return list;
    } catch (e) {
      debugPrint('[Error] getMedicines failed: $e');
      throw StorageException('Failed to retrieve medicines', originalError: e);
    }
  }

  Medicine getMedicineById(String id) {
    try {
      final medicine = _box.get(id);
      if (medicine == null) {
        throw NotFoundException('Medicine not found', id);
      }
      return medicine;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw StorageException('Failed to retrieve medicine', originalError: e);
    }
  }

  void addMedicine(Medicine medicine) {
    debugPrint('[Hive] addMedicine called: id=${medicine.id}, name=${medicine.name}');
    try {
      _box.put(medicine.id, medicine);
      debugPrint('[Hive] addMedicine succeeded: id=${medicine.id}');
    } catch (e) {
      debugPrint('[Error] addMedicine failed: $e');
      throw StorageException('Failed to save medicine', originalError: e);
    }
  }

  void updateMedicine(Medicine medicine) {
    debugPrint('[Hive] updateMedicine called: id=${medicine.id}, name=${medicine.name}');
    try {
      if (!_box.containsKey(medicine.id)) {
        throw NotFoundException('Medicine not found', medicine.id);
      }
      _box.put(medicine.id, medicine);
      debugPrint('[Hive] updateMedicine succeeded: id=${medicine.id}');
    } catch (e) {
      debugPrint('[Error] updateMedicine failed: $e');
      if (e is NotFoundException) rethrow;
      throw StorageException('Failed to update medicine', originalError: e);
    }
  }

  void deleteMedicine(String id) {
    debugPrint('[Hive] deleteMedicine called: id=$id');
    try {
      if (!_box.containsKey(id)) {
        throw NotFoundException('Medicine not found', id);
      }
      _box.delete(id);
      debugPrint('[Hive] deleteMedicine succeeded: id=$id');
    } catch (e) {
      debugPrint('[Error] deleteMedicine failed: $e');
      if (e is NotFoundException) rethrow;
      throw StorageException('Failed to delete medicine', originalError: e);
    }
  }

  void clearAllMedicines() {
    try {
      _box.clear();
    } catch (e) {
      throw StorageException('Failed to clear medicines', originalError: e);
    }
  }
}
