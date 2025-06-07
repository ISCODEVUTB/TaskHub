import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/data/auth_models.dart'; // For UserProfileDTO
import '../../../core/constants/strings.dart'; // Assuming AppStrings is here if used
import '../../../core/constants/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Consumer to react to changes in AuthService, particularly currentUser
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final UserProfileDTO? currentUser = authService.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil'),
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
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/dashboard'); // Fallback if cannot pop
                }
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary.withAlpha(38),
                  child: const Icon(
                    Icons.person,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  currentUser?.fullName ?? 'Nombre de Usuario',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  currentUser?.email ?? 'usuario@email.com',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading: const Icon(Icons.edit, color: AppColors.primary),
                    title: const Text('Editar perfil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Feedback.forTap(context);
                      context.go('/edit-user');
                    },
                  ),
                ),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading: const Icon(Icons.settings, color: AppColors.primary),
                    title: const Text('Configuración de cuenta'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Feedback.forTap(context);
                      context.go('/account-settings');
                    },
                  ),
                ),
                const SizedBox(height: 16), // Spacer before logout button
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error), // Corrected color
                    title: const Text('Cerrar Sesión'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      Feedback.forTap(context);
                      // No need to check mounted here if using listen:false and context is from builder
                      await Provider.of<AuthService>(context, listen: false).signOut();
                      // After signOut, the auth state changes, potentially rebuilding widgets.
                      // The GoRouter redirect/listen logic in main.dart should handle redirecting to /login
                      // if the user is no longer authenticated.
                      // However, an explicit navigation here is also fine.
                      // Ensure context is still valid if operations are long.
                      // A common pattern is for signOut to trigger state change that router listens to.
                      // For direct navigation:
                      if (context.mounted) { // Check mounted before async gap if any or if context might become invalid
                         context.go('/login');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
