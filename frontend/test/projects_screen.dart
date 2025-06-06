import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          // Crear un ID para el proyecto
          final projectId = (index + 1).toString();

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text('Proyecto $projectId'),
              subtitle: Text(
                'Creado el ${DateTime.now().toLocal().toIso8601String().substring(0, 10)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navegar a la página de detalles del proyecto
                context.push('/project/$projectId');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la página de creación de proyecto
          context.push('/create-project');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
