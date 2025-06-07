import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../../core/constants/colors.dart';
import 'package:go_router/go_router.dart'; // Already present, ensure it stays
// import '../../../core/widgets/navigation_utils.dart'; // Not used in my generated code for this screen
import '../data/document_service.dart'; // Path adjusted
import '../data/document_models.dart';  // Path adjusted

class DocumentDetailScreen extends StatefulWidget {
  final String documentId;
  final String projectId;

  const DocumentDetailScreen({
    super.key,
    required this.documentId,
    required this.projectId,
  });

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  final DocumentService _documentService = DocumentService(); // Added instance
  DocumentDTO? _document;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDocumentDetails(); // Renamed call
  }

  Future<void> _fetchDocumentDetails() async { // Renamed method
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // documentId is now required, no null check needed for widget.documentId itself
      final doc = await _documentService.getDocumentById(widget.documentId); // _documentService is now a class member
      if (mounted) {
        setState(() {
          _document = doc;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar el documento: ${e.toString()}'; // Improved error message
        });
      }
    } finally {
      if (mounted) { // mounted check for finally block
        setState(() {
          _loading = false;
        }); // Corrected brace
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Documento'), // Changed title
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
      body: _buildBody(), // Updated to call _buildBody
    );
  }

  Widget _buildBody() { // New _buildBody structure
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    }
    if (_document == null) {
      return const Center(child: Text('Documento no encontrado.'));
    }

    final doc = _document!;
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(doc.name, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildDetailItem(Icons.description, 'Descripción:', doc.description ?? 'Sin descripción'),
        _buildDetailItem(Icons.folder_special, 'Tipo:', doc.type.toString().split('.').last),
        _buildDetailItem(Icons.inventory_2, 'Proyecto ID:', doc.projectId), // Displaying projectId from widget
        _buildDetailItem(Icons.person, 'Creador ID:', doc.creatorId),
        _buildDetailItem(Icons.tag, 'Versión:', doc.version.toString()),
        _buildDetailItem(Icons.calendar_today, 'Creado:', dateFormat.format(doc.createdAt.toLocal())),
        if (doc.updatedAt != null)
          _buildDetailItem(Icons.edit_calendar, 'Actualizado:', dateFormat.format(doc.updatedAt!.toLocal())),
        if (doc.type == DocumentType.LINK && doc.url != null && doc.url!.isNotEmpty)
          _buildDetailItem(Icons.link, 'URL:', doc.url!),
        if (doc.contentType != null && doc.contentType!.isNotEmpty)
          _buildDetailItem(Icons.attachment, 'Tipo de Contenido:', doc.contentType!),
        if (doc.size != null)
          _buildDetailItem(Icons.sd_storage, 'Tamaño:', '${(doc.size! / 1024).toStringAsFixed(2)} KB'), // Formatted size
        if (doc.tags != null && doc.tags!.isNotEmpty)
          _buildDetailItem(Icons.label, 'Tags:', doc.tags!.join(', ')),
        if (doc.metaData != null && doc.metaData!.isNotEmpty)
          _buildDetailItem(Icons.data_object, 'Metadata:', doc.metaData.toString()),

        const SizedBox(height: 24),
        Text(
          'Acciones (TODO):',
          style: textTheme.titleMedium,
        ),
        ListTile(
          leading: const Icon(Icons.open_in_new),
          title: const Text('Abrir/Descargar'),
          onTap: () {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidad de abrir/descargar no implementada.')),
            );
          },
        ),
         ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Ver Versiones'),
          onTap: () {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidad de ver versiones no implementada.')),
            );
          },
        ),
        // Note: The FloatingActionButton for edit is removed in this version of _buildBody
        // as it was part of the Stack in the original file's build method.
        // If it needs to be kept, it should be added back to the Scaffold in the main build method.
        // For this refactoring, I'm focusing on replacing _buildDetail with _buildBody + _buildDetailItem.
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) { // New helper method
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}