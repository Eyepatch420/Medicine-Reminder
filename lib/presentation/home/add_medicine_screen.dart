import 'package:flutter/material.dart';

class AddMedicineScreen extends StatelessWidget {
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: const Center(
        child: Text(
          'Add Medicine Screen - To be implemented',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
