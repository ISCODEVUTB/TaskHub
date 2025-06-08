import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/section_card.dart';
import '../../home/data/document_service.dart';
import '../../home/data/document_models.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentDTO> _documents = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Aquí deberías obtener el projectId real según el contexto de tu app
      final projectId = 'demo_project_id';
      final docs = await DocumentService().getProjectDocuments(projectId);
      setState(() {
        _documents = docs;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _documents.isEmpty
                  ? const Center(child: Text('No hay documentos'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(24.0),
                      itemCount: _documents.length,
                      separatorBuilder: (context, index) => Divider(height: 24, color: Theme.of(context).dividerColor),
                      itemBuilder: (context, index) {
                        final doc = _documents[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.secondary.withAlpha(38),
                              child: Icon(
                                doc.type == 'folder'
                                    ? Icons.folder
                                    : doc.type == 'link'
                                        ? Icons.link
                                        : Icons.insert_drive_file,
                                color: AppColors.secondary,
                              ),
                            ),
                            title: Text(
                              doc.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (doc.description != null) Text(doc.description!),
                                Text('Tipo: ${doc.type}'),
                                if (doc.tags != null && doc.tags!.isNotEmpty) Text('Tags: ${doc.tags!.join(", ")}'),
                                Text('Creado: ${doc.createdAt}'),
                              ],
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
                              context.go('/project/${doc.projectId}/document/${doc.id}');
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
