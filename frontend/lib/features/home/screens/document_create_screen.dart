import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class DocumentCreateScreen extends StatelessWidget {
  const DocumentCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear documento'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        toolbarHeight: 48,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: const Center(
        child: Text('Formulario para crear documento (próximamente)'),
      ),
    );
  }
} 