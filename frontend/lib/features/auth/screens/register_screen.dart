import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/auth_service.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // final _companyNameController = TextEditingController(); // Add if UI field is added
  String? _error;
  bool _isLoading = false;

  void _register() async {
    print('[RegisterScreen] _register method CALLED');
    setState(() {
      _error = null;
      _isLoading = true;
    });

    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _error = 'Por favor, completa todos los campos obligatorios.';
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _error = 'Las contraseñas no coinciden';
        _isLoading = false;
      });
      return;
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      // Assuming companyName is optional and can be passed as null if not collected.
      // If a _companyNameController is added, use its text value.
      await authService.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        null, // Passing null for companyName
        // _companyNameController.text.trim(), // Use if a company name field is added
      );

      if (!mounted) return;
      context.go('/dashboard');

    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Registration failed. Please try again.';
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
                      'Crear cuenta',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Nombre completo',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirmar contraseña',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: _isLoading ? 'Creando cuenta...' : 'Crear cuenta',
                      onPressed: _isLoading ? null : _register,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Feedback.forTap(context);
                        GoRouter.of(context).go('/login');
                      },
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('¿Ya tienes cuenta? Inicia sesión'),
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
