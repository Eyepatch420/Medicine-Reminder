import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/medicine_provider.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/medicine_card.dart';
import '../add/add_medicine_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(medicineProvider.notifier).loadMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicines = ref.watch(medicineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminder'),
      ),
      body: medicines.isEmpty
          ? const EmptyStateWidget()
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(medicineProvider.notifier).loadMedicines();
              },
              child: ListView.builder(
                itemCount: medicines.length,
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemBuilder: (context, index) {
                  return MedicineCard(medicine: medicines[index]);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicineScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }


}
