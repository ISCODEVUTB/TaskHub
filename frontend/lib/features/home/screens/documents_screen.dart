import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentos'),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: 4,
        separatorBuilder:
            (context, index) => Divider(height: 24, color: Theme.of(context).dividerColor),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.secondary.withAlpha(38),
                child: const Icon(
                  Icons.insert_drive_file,
                  color: AppColors.secondary,
                ),
              ),
              title: Text(
                'Documento ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Subido el 2025-06-0${index + 1}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.download, color: AppColors.primary),
                tooltip: 'Descargar documento',
                onPressed: () {
                  Feedback.forTap(context);
                  // Acción de descarga aquí
                },
              ),
              onTap: () {
                Feedback.forTap(context);
                context.go('/document/${index + 1}');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create-document'),
        tooltip: 'Crear documento',
        child: const Icon(Icons.add),
      ),
    );
  }
}
