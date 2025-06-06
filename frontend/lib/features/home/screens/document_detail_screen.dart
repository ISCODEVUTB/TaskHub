import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/navigation_utils.dart';
import '../../home/data/document_service.dart';
import '../../home/data/document_models.dart';

class DocumentDetailScreen extends StatefulWidget {
  final String? documentId;
  const DocumentDetailScreen({super.key, this.documentId});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  DocumentDTO? _document;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDocument();
  }

  Future<void> _fetchDocument() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (widget.documentId == null) throw Exception('ID de documento no proporcionado');
      final doc = await DocumentService().getDocumentById(widget.documentId!);
      setState(() {
        _document = doc;
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

  Widget _buildDetail(DocumentDTO doc) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(doc.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('ID: ${doc.id}'),
        Text('Proyecto: ${doc.projectId}'),
        if (doc.parentId != null) Text('Carpeta padre: ${doc.parentId}'),
        Text('Tipo: ${doc.type}'),
        if (doc.contentType != null) Text('Content-Type: ${doc.contentType}'),
        if (doc.size != null) Text('Tamaño: ${doc.size} bytes'),
        if (doc.url != null) Text('URL: ${doc.url}'),
        if (doc.description != null) Text('Descripción: ${doc.description}'),
        Text('Versión: ${doc.version}'),
        Text('Creador: ${doc.creatorId}'),
        if (doc.tags != null && doc.tags!.isNotEmpty) Text('Tags: ${doc.tags!.join(", ")}'),
        if (doc.metaData != null && doc.metaData!.isNotEmpty) Text('MetaData: ${doc.metaData}'),
        Text('Creado: ${doc.createdAt}'),
        if (doc.updatedAt != null) Text('Actualizado: ${doc.updatedAt}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documento ${widget.documentId ?? ''}'),
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
              : _document == null
                  ? const Center(child: Text('Documento no encontrado'))
                  : _buildDetail(_document!),
    );
  }
} 