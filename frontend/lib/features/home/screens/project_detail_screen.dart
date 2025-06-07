import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/project_service.dart';
import '../data/project_models.dart';
import '../data/document_service.dart';
import '../data/document_models.dart';
import './document_detail_screen.dart';
import 'task_detail_screen.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/navigation_utils.dart';
import '../../../core/constants/colors.dart'; // Added AppColors import

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
  final DocumentService _documentService = DocumentService(); // Added

  ProjectDTO? _project;
  List<ProjectMemberDTO> _members = [];
  List<TaskDTO> _tasks = [];
  List<ActivityDTO> _activities = [];
  List<DocumentDTO> _projectDocuments = []; // Added
  bool _projectDocumentsLoading = true;   // Added
  String? _projectDocumentsError;         // Added
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
      await _fetchProjectDocuments(); // Call to fetch documents
      setState(() {
        _project = project;
        _members = members;
        _tasks = tasks;
        _activities = activities;
        _isLoading = false; // Overall loading for project details
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar datos del proyecto: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProjectDocuments() async {
    if (widget.projectId == null) return;
    // Document loading state is managed by _projectDocumentsLoading
    // No need to set _isLoading here as it's for the main project data.
    // If _loadAll sets _isLoading to true, this will run concurrently or sequentially.
    // For clarity, let's manage its own loading state and not interfere with _isLoading for the whole page.
    setState(() {
      _projectDocumentsLoading = true;
      _projectDocumentsError = null;
    });
    try {
      final docs = await _documentService.getProjectDocuments(widget.projectId!);
      if (mounted) {
        setState(() {
          _projectDocuments = docs;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _projectDocumentsError = 'Error al cargar documentos: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _projectDocumentsLoading = false;
        });
      }
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
                    _buildDocumentsTab(), // Updated
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
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog first

                  if (widget.projectId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: ID de proyecto no disponible.')),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);
                  try {
                    await _service.deleteProject(widget.projectId!);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proyecto eliminado correctamente')),
                      );
                      context.pop(); // Navigate back
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al eliminar proyecto: $e')),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  }
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

  Widget _buildDocumentsTab() {
    if (_projectDocumentsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_projectDocumentsError != null) {
      return Center(child: Text(_projectDocumentsError!, style: const TextStyle(color: Colors.red)));
    }
    if (_projectDocuments.isEmpty) {
      return const Center(child: Text('No hay documentos en este proyecto.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _projectDocuments.length,
      itemBuilder: (context, index) {
        final doc = _projectDocuments[index];
        IconData docIcon;
        switch (doc.type) {
          case DocumentType.FOLDER:
            docIcon = Icons.folder;
            break;
          case DocumentType.LINK:
            docIcon = Icons.link;
            break;
          case DocumentType.FILE:
          default:
            docIcon = Icons.insert_drive_file;
            break;
        }
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: Icon(docIcon, color: AppColors.primary, size: 30),
            title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(doc.description ?? 'Tipo: ${doc.type.toString().split('.').last} - ${doc.createdAt.toLocal().toString().substring(0,16)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (widget.projectId != null) {
                context.push('/project/${widget.projectId}/document/${doc.id}');
              } else {
                // Handle case where projectId is null, though it shouldn't be at this point
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Project ID no disponible.')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
