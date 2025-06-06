import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/auth_service.dart';
// UserProfileDTO is not directly used in this screen after AuthService.login refactor,
// but good to have if we were to receive UserProfileDTO here.
// import '../data/auth_models.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  void _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      // AuthService.login now handles setting the user state and returns UserProfileDTO
      // We don't need to use the returned UserProfileDTO directly here unless for specific UI update before navigation
      await authService.login(_emailController.text.trim(), _passwordController.text.trim());

      if (!mounted) return;
      context.go('/dashboard');

    } catch (e) {
      if (mounted) {
        setState(() {
          // You can customize error messages based on exception type if needed
          _error = 'Login failed. Please check your credentials or network connection.';
          // Example of more specific error:
          // _error = e is Exception ? e.toString().replaceFirst("Exception: ", "") : 'An unknown error occurred.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 36,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.task_alt_rounded, color: Color(0xFF4E88FF), size: 48),
                        SizedBox(width: 12),
                        Text('TaskHub', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1F2937), letterSpacing: 1.2)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Iniciar sesión',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Contraseña',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: _isLoading ? 'Cargando...' : 'Iniciar sesión',
                      onPressed: _isLoading
                          ? null
                          : () {
                              Feedback.forTap(context);
                              _login();
                            },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Feedback.forTap(context);
                        context.go('/register');
                      },
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('¿No tienes cuenta? Regístrate'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
