import 'package:flutter/material.dart';

class ProjectDetailPage extends StatefulWidget {
  final String? projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Datos simulados del proyecto
  late Map<String, dynamic> _projectData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadProjectData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Método para cargar los datos del proyecto
  Future<void> _loadProjectData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulamos una carga de datos
      await Future.delayed(const Duration(milliseconds: 800));

      // En una aplicación real, aquí harías una llamada a tu API
      // final response = await projectService.getProjectById(widget.projectId);

      // Datos simulados para demostración
      _projectData = {
        'id': widget.projectId,
        'name': 'Proyecto ${widget.projectId}',
        'description': 'Descripción detallada del proyecto ${widget.projectId}',
        'startDate': '2023-06-01',
        'endDate': '2023-12-31',
        'status': 'En progreso',
        'progress': 0.65,
        'members': [
          {'id': '1', 'name': 'Ana García', 'role': 'Project Manager'},
          {'id': '2', 'name': 'Carlos López', 'role': 'Developer'},
          {'id': '3', 'name': 'María Rodríguez', 'role': 'Designer'},
        ],
        'tasks': [
          {
            'id': '1',
            'title': 'Diseño de UI',
            'status': 'Completado',
            'assignee': 'María Rodríguez',
          },
          {
            'id': '2',
            'title': 'Implementación Backend',
            'status': 'En progreso',
            'assignee': 'Carlos López',
          },
          {
            'id': '3',
            'title': 'Testing',
            'status': 'Pendiente',
            'assignee': 'Ana García',
          },
        ],
        'documents': [
          {
            'id': '1',
            'name': 'Especificaciones.pdf',
            'type': 'PDF',
            'date': '2023-06-05',
          },
          {
            'id': '2',
            'name': 'Diseño.fig',
            'type': 'Figma',
            'date': '2023-06-10',
          },
        ],
        'activities': [
          {
            'id': '1',
            'description': 'María subió un nuevo documento',
            'date': '2023-06-10',
          },
          {
            'id': '2',
            'description': 'Carlos completó la tarea "Configuración inicial"',
            'date': '2023-06-08',
          },
          {
            'id': '3',
            'description': 'Ana creó el proyecto',
            'date': '2023-06-01',
          },
        ],
      };

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error al cargar los datos del proyecto: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isLoading
                ? const Text('Cargando proyecto...')
                : Text(_projectData['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navegar a la pantalla de edición del proyecto
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de edición no implementada'),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar proyecto'),
                  ),
                ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Resumen'),
            Tab(text: 'Tareas'),
            Tab(text: 'Documentos'),
            Tab(text: 'Actividad'),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadProjectData,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildSummaryTab(),
                  _buildTasksTab(),
                  _buildDocumentsTab(),
                  _buildActivityTab(),
                ],
              ),
      floatingActionButton:
          _tabController.index == 1
              ? FloatingActionButton(
                onPressed: () {
                  // Acción para añadir nueva tarea
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Función para añadir tarea no implementada',
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
              : null,
    );
  }

  // Tab de resumen del proyecto
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información general',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  _infoRow('Estado:', _projectData['status']),
                  _infoRow('Fecha inicio:', _projectData['startDate']),
                  _infoRow('Fecha fin:', _projectData['endDate']),
                  const SizedBox(height: 8),
                  Text(
                    'Progreso: ${(_projectData['progress'] * 100).toInt()}%',
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _projectData['progress'],
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Text(_projectData['description']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Miembros del equipo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Función para añadir miembro no implementada',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  ...(_projectData['members'] as List)
                      .map(
                        (member) => ListTile(
                          leading: CircleAvatar(child: Text(member['name'][0])),
                          title: Text(member['name']),
                          subtitle: Text(member['role']),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab de tareas
  Widget _buildTasksTab() {
    final tasks = _projectData['tasks'] as List;
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Text(task['title']),
            subtitle: Text('Asignado a: ${task['assignee']}'),
            trailing: Chip(
              label: Text(task['status']),
              backgroundColor: _getStatusColor(task['status']),
            ),
            onTap: () {
              // Navegar a los detalles de la tarea
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Detalles de la tarea: ${task['title']}'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Tab de documentos
  Widget _buildDocumentsTab() {
    final documents = _projectData['documents'] as List;
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            leading: Icon(_getFileIcon(document['type'])),
            title: Text(document['name']),
            subtitle: Text('Subido el: ${document['date']}'),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Descargando ${document['name']}...')),
                );
              },
            ),
            onTap: () {
              // Abrir el documento
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abriendo ${document['name']}...')),
              );
            },
          ),
        );
      },
    );
  }

  // Tab de actividad
  Widget _buildActivityTab() {
    final activities = _projectData['activities'] as List;
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.history)),
            title: Text(activity['description']),
            subtitle: Text('Fecha: ${activity['date']}'),
          ),
        );
      },
    );
  }

  // Método para mostrar filas de información
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  // Método para obtener el color según el estado
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completado':
        return Colors.green.shade100;
      case 'En progreso':
        return Colors.blue.shade100;
      case 'Pendiente':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // Método para obtener el icono según el tipo de archivo
  IconData _getFileIcon(String fileType) {
    switch (fileType) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'Figma':
        return Icons.design_services;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Método para mostrar el diálogo de confirmación de eliminación
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar proyecto'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar este proyecto? Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // Cerrar el diálogo
                  Navigator.of(context).pop();

                  // Simular eliminación
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Proyecto eliminado correctamente'),
                    ),
                  );

                  // Volver a la pantalla anterior
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
