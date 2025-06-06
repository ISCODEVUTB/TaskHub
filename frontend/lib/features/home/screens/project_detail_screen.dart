import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/project_service.dart';
import '../data/project_models.dart';
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
  final ProjectService _service = ProjectService();

  ProjectDTO? _project;
  List<ProjectMemberDTO> _members = [];
  List<TaskDTO> _tasks = [];
  List<ActivityDTO> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final project = await _service.getProjectById(widget.projectId!);
      final members = await _service.getProjectMembers(widget.projectId!);
      final tasks = await _service.getProjectTasks(widget.projectId!);
      final activities = await _service.getProjectActivities(widget.projectId!);
      setState(() {
        _project = project;
        _members = members;
        _tasks = tasks;
        _activities = activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar datos: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Cargando proyecto...')
            : Flexible(child: Text(_project?.name ?? '')),
        toolbarHeight: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () => context.pop(),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSummaryTab(),
                    _buildTasksTab(),
                    Center(child: Text('Aquí puedes integrar documentos')), // Puedes usar DocumentService aquí
                    _buildActivityTab(),
                  ],
                ),
    );
  }

  Widget _buildSummaryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(_project?.description ?? '', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text('Miembros:', style: Theme.of(context).textTheme.titleMedium),
          ..._members.map((m) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(m.userId),
                subtitle: Text(m.role),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  tooltip: 'Eliminar miembro',
                  onPressed: () async {
                    try {
                      await _service.removeProjectMember(
                        projectId: widget.projectId!,
                        memberId: m.id,
                      );
                      await _loadAll();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al eliminar miembro: $e')),
                      );
                    }
                  },
                ),
              )),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text('Agregar miembro'),
            onPressed: () async {
              final userIdController = TextEditingController();
              final roleController = TextEditingController(text: 'member');
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Agregar miembro'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: userIdController,
                        decoration: const InputDecoration(labelText: 'ID de usuario'),
                      ),
                      TextField(
                        controller: roleController,
                        decoration: const InputDecoration(labelText: 'Rol'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await _service.addProjectMember(
                            projectId: widget.projectId!,
                            userId: userIdController.text,
                            role: roleController.text,
                          );
                          Navigator.of(context).pop();
                          await _loadAll();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al agregar miembro: $e')),
                          );
                        }
                      },
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _tasks.length,
      separatorBuilder: (context, index) => Divider(height: 24, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: StatusBadge(status: task.status),
            title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Asignado a: ${task.assigneeId ?? "Sin asignar"}'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => TaskDetailScreen(
                    taskId: task.id,
                    projectId: task.projectId,
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
    );
  }

  Widget _buildActivityTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _activities.length,
      separatorBuilder: (context, index) => Divider(height: 24, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final activity = _activities[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(activity.action),
          subtitle: Text(activity.createdAt.toString()),
        );
      },
    );
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
}
