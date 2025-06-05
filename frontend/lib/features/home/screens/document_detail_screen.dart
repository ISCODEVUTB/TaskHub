import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/navigation_utils.dart';

class DocumentDetailScreen extends StatelessWidget {
  final String? documentId;
  const DocumentDetailScreen({super.key, this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documento $documentId'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        toolbarHeight: 48,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () {
            Feedback.forTap(context);
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Text('Detalle del documento $documentId'),
      ),
    );
  }
} 