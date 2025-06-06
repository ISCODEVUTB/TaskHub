import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/dashboard_screen.dart';
import '../features/home/screens/projects_screen.dart';
import '../features/home/screens/project_create_screen.dart';
import '../features/home/screens/project_edit_screen.dart';
import '../features/home/screens/project_detail_screen.dart';
import '../features/home/screens/create_task_screen.dart';
import '../features/home/screens/task_detail_screen.dart';
import '../features/home/screens/documents_screen.dart';
import '../features/home/screens/document_create_screen.dart';
import '../features/home/screens/document_detail_screen.dart';
import '../features/home/screens/notifications_screen.dart';
import '../features/home/screens/notifications_preferences_screen.dart';
import '../features/home/screens/externaltools_screen.dart';
import '../features/home/screens/tool_calendar_screen.dart';
import '../features/home/screens/tool_chat_screen.dart';
import '../features/home/screens/tool_analytics_screen.dart';
import '../features/home/screens/profile_screen.dart';
import '../features/home/screens/account_settings_screen.dart';
import '../features/home/screens/change_password_screen.dart';
import '../features/home/screens/user_edit_screen.dart';
import '../core/constants/colors.dart';
import '../core/constants/strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../features/auth/data/auth_service.dart';

// Shell to provide persistent navigation
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({required this.child, super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _routes = [
    '/dashboard',
    '/projects',
    '/documents',
    '/notifications',
    '/tools',
    '/profile',
  ];

  bool _extended = true;

  int _selectedIndexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    // Mejor lógica: si la ruta contiene la base, resalta el icono
    for (int i = 0; i < _routes.length; i++) {
      if (location == _routes[i] || location.startsWith(_routes[i] + '/') ||
          (i == 1 && location.startsWith('/project')) || // Proyectos e hijas
          (i == 2 && location.startsWith('/document')) || // Documentos e hijas
          (i == 4 && location.startsWith('/tool')) // Herramientas e hijas
      ) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndexFromLocation(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: NavigationRail(
              extended: _extended,
              minExtendedWidth: 200,
              backgroundColor: theme.colorScheme.surface.withAlpha(250),
              elevation: 2,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(_extended ? Icons.arrow_back : Icons.menu),
                      onPressed: () => setState(() => _extended = !_extended),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _extended
                        ? Row(
                            key: const ValueKey('expanded'),
                            children: const [
                              Icon(Icons.task_alt_rounded, color: AppColors.primary, size: 40),
                              SizedBox(width: 12),
                              Text(
                                'TaskHub',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          )
                        : const Icon(Icons.task_alt_rounded, color: AppColors.primary, size: 40, key: ValueKey('collapsed')),
                    ),
                  ],
                ),
              ),
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                if (_routes[index] != GoRouterState.of(context).uri.toString()) {
                  GoRouter.of(context).go(_routes[index]);
                }
              },
              selectedIconTheme: const IconThemeData(size: 32, color: AppColors.primary),
              unselectedIconTheme: IconThemeData(size: 28, color: theme.iconTheme.color?.withAlpha(179)),
              labelType: _extended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  selectedIcon: Icon(Icons.dashboard_customize, color: AppColors.primary),
                  label: Text(AppStrings.homeTitle),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.folder),
                  selectedIcon: Icon(Icons.folder_open, color: AppColors.primary),
                  label: Text(AppStrings.projectsTitle),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.description),
                  selectedIcon: Icon(Icons.description_outlined, color: AppColors.primary),
                  label: Text(AppStrings.documentsTitle),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.notifications),
                  selectedIcon: Icon(Icons.notifications_active, color: AppColors.primary),
                  label: Text(AppStrings.notificationsTitle),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.extension),
                  selectedIcon: Icon(Icons.extension_rounded, color: AppColors.primary),
                  label: Text(AppStrings.toolsTitle),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  selectedIcon: Icon(Icons.verified_user, color: AppColors.primary),
                  label: Text(AppStrings.profileTitle),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      // Permitir acceso libre a login y register
      if (state.matchedLocation == '/login' || state.matchedLocation == '/register') {
        return null;
      }
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        return '/login';
      }
      // Verificar perfil (opcional: puedes cachear el resultado)
      try {
        final profile = await AuthService().getProfile();
        // Si quieres forzar verificación, puedes chequear un campo aquí
        // if (!profile.isVerified) return '/login';
        return null;
      } catch (_) {
        return '/login';
      }
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectsPage(),
          ),
          GoRoute(
            path: '/create-project',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const CreateProjectPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentsPage(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/notification-settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const NotificationsPreferencesScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/account-settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const AccountSettingsPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/change-password',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ChangePasswordScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/tools',
            builder: (context, state) => const ExternalToolsScreen(),
          ),
          GoRoute(
            path: '/tool/calendario',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ToolCalendarScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/tool/chat',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ToolChatScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/tool/analytics',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ToolAnalyticsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/project/:id',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: ProjectDetailPage(projectId: state.pathParameters['id']),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/project/:id/create-task',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: CreateTaskScreen(projectId: state.pathParameters['id']),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/task/:id',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: TaskDetailScreen(taskId: state.pathParameters['id']),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/edit-project/:id',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: ProjectEditScreen(projectId: state.pathParameters['id']),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/edit-user',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const UserEditScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/document/:id',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: DocumentDetailScreen(documentId: state.pathParameters['id']),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: '/create-document',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const DocumentCreateScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            ),
          ),
        ],
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
