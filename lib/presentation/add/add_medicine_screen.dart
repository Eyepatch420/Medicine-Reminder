import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../state/medicine_provider.dart';
import 'widgets/medicine_dropdown.dart';
import 'widgets/dosage_text_field.dart';
import 'widgets/time_picker_button.dart';
import 'widgets/save_button.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dosageController = TextEditingController();
  
  String? _selectedMedicine;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _dosageController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    debugPrint('[UI] Save button tapped');
    if (!_formKey.currentState!.validate()) {
      debugPrint('[UI] Validation failed');
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reminder time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    debugPrint('[UI] Validation passed, preparing to call provider');
    try {
      debugPrint('[UI] Calling provider.addMedicine');
      await ref.read(medicineProvider.notifier).addMedicine(
            _selectedMedicine!,
            _dosageController.text.trim(),
            _selectedTime!.hour,
            _selectedTime!.minute,
          );

      debugPrint('[UI] Provider.addMedicine completed successfully');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medicine added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('[Error] Add medicine failed in UI: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add medicine: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              
              // Medicine Name Dropdown
              MedicineDropdown(
                selectedValue: _selectedMedicine,
                onChanged: (value) {
                  setState(() {
                    _selectedMedicine = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Dosage TextField
              DosageTextField(
                controller: _dosageController,
              ),
              
              const SizedBox(height: 16),
              
              // Time Picker
              TimePickerButton(
                selectedTime: _selectedTime,
                onPickTime: _pickTime,
              ),
              
              const SizedBox(height: 32),
              
              // Save Button
              SaveButton(
                isLoading: _isLoading,
                onSave: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
