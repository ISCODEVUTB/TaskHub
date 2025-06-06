import 'package:flutter/material.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentos'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text('Documento ${index + 1}'),
              subtitle: Text('Proyecto relacionado #${index + 1}'),
              trailing: Wrap(
                spacing: 8,
                children: const [
                  Icon(Icons.download),
                  Icon(Icons.share),
                  Icon(Icons.edit),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}