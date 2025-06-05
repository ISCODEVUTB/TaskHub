import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'task_detail_screen.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/navigation_utils.dart';

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
                : Flexible(child: Text(_projectData['name'])),
        toolbarHeight: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () => smartPop(context, fallbackRoute: '/projects'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar proyecto',
            onPressed: () {
              context.push('/edit-project/${widget.projectId}');
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
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blueAccent,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Información general',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(),
                  _infoRow('Estado:', _projectData['status']),
                  _infoRow('Fecha inicio:', _projectData['startDate']),
                  _infoRow('Fecha fin:', _projectData['endDate']),
                  const SizedBox(height: 8),
                  Text(
                    'Progreso: ${(_projectData['progress'] * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      LinearProgressIndicator(
                        value: _projectData['progress'],
                        minHeight: 14,
                        borderRadius: BorderRadius.circular(7),
                        backgroundColor: Theme.of(context).dividerColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${(_projectData['progress'] * 100).toInt()}%',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 2, color: Colors.black26),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: Theme.of(context).iconTheme.color, size: 26),
                      const SizedBox(width: 10),
                      Text(
                        'Descripción',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    _projectData['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.group, color: Colors.deepPurple, size: 26),
                      const SizedBox(width: 10),
                      Text(
                        'Miembros del equipo',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _showAddMemberDialog,
                        tooltip: 'Agregar miembro',
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
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: tasks.length,
          separatorBuilder:
              (context, index) => Divider(height: 24, color: Colors.grey[300]),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: PopupMenuButton<String>(
                  initialValue: task['status'],
                  onSelected: (value) {
                    setState(() {
                      task['status'] = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Pendiente',
                      child: Text('Pendiente'),
                    ),
                    const PopupMenuItem(
                      value: 'En progreso',
                      child: Text('En progreso'),
                    ),
                    const PopupMenuItem(
                      value: 'Completado',
                      child: Text('Completado'),
                    ),
                  ],
                  child: StatusBadge(status: task['status']),
                ),
                title: Text(
                  task['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asignado a: ${task['assignee']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                    ),
                    if (task['dueDate'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Vence: ${task['dueDate'] ?? "-"}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).iconTheme.color,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => TaskDetailScreen(
                        taskId: task['id'],
                        taskData: task,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton.extended(
            onPressed: () {
              Feedback.forTap(context);
              context.go('/project/${widget.projectId}/create-task');
            },
            icon: const Icon(Icons.add),
            label: const Text('Nueva tarea'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            tooltip: 'Añadir tarea',
          ),
        ),
      ],
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
                Feedback.forTap(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Descargando ${document['name']}...',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black.withAlpha(242),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            onTap: () {
              Feedback.forTap(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Abriendo ${document['name']}...',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black.withAlpha(242),
                  behavior: SnackBarBehavior.floating,
                ),
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
                    SnackBar(
                      content: const Text(
                        'Proyecto eliminado correctamente',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black.withAlpha(242),
                      behavior: SnackBarBehavior.floating,
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

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController _roleController = TextEditingController();
        return AlertDialog(
          title: const Text('Agregar miembro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar lógica para añadir el miembro
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Miembro agregado',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black.withAlpha(242),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}
