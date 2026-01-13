import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../core/models/medicine.dart';
import '../data/hive_service.dart';
import '../data/notification_service.dart';
import '../domain/medicine_service.dart';

// Service providers
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final medicineServiceProvider = Provider<MedicineService>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  // MedicineService constructor expects only HiveService in the current API
  return MedicineService(hiveService);
});

// State provider
final medicineProvider = NotifierProvider<MedicineNotifier, List<Medicine>>(() {
  return MedicineNotifier();
});

class MedicineNotifier extends Notifier<List<Medicine>> {
  late final MedicineService _medicineService;

  @override
  List<Medicine> build() {
    _medicineService = ref.read(medicineServiceProvider);
    debugPrint('[Provider] Initializing MedicineNotifier and loading data');
    _loadInitialData();
    return [];
  }

  Future<void> _loadInitialData() async {
    debugPrint('[Provider] _loadInitialData start');
    try {
      final medicines = _medicineService.getAllMedicines();
      state = _sortByTime(medicines);
      debugPrint('[Provider] _loadInitialData completed, loaded ${state.length} medicines');
    } catch (e) {
      debugPrint('[Error] Error loading medicines: $e');
      state = [];
    }
  }

  Future<void> loadMedicines() async {
    await _loadInitialData();
  }

  Future<void> addMedicine(
    String name,
    String dosage,
    int hour,
    int minute,
  ) async {
    debugPrint('[Provider] addMedicine start: name=$name, hour=$hour, minute=$minute');
    final medicine = await _medicineService.addMedicine(name, dosage, hour, minute);
    state = _sortByTime([...state, medicine]);
    debugPrint('[Provider] addMedicine updated state, total=${state.length}');
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await _medicineService.updateMedicine(medicine);
    state = _sortByTime(
      state.map((m) => m.id == medicine.id ? medicine : m).toList(),
    );
  }

  Future<void> deleteMedicine(String id) async {
    await _medicineService.deleteMedicine(id);
    state = state.where((m) => m.id != id).toList();
  }

  Future<void> toggleActive(String id) async {
    final updatedMedicine = await _medicineService.toggleMedicineActive(id);
    state = state.map((m) => m.id == id ? updatedMedicine : m).toList();
  }

  List<Medicine> _sortByTime(List<Medicine> medicines) {
    final sorted = [...medicines];
    sorted.sort((a, b) {
      if (a.hour != b.hour) {
        return a.hour.compareTo(b.hour);
      }
      return a.minute.compareTo(b.minute);
    });
    return sorted;
  }
}
