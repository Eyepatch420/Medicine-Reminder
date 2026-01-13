import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class MedicineDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const MedicineDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedValue,
      decoration: const InputDecoration(
        labelText: 'Medicine Name',
        prefixIcon: Icon(Icons.medication),
      ),
      items: AppConstants.medicineNames.map((name) {
        return DropdownMenuItem(
          value: name,
          child: Text(name),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a medicine';
        }
        return null;
      },
    );
  }
}
