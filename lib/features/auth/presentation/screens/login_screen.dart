import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/pages/login_page.dart';
import 'package:atomic_design_system/atoms/buttons/primary_button.dart';
import 'package:atomic_design_system/atoms/text_fields/custom_text_field.dart';

import '../providers/auth_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/error_message.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return LoginPage(
      form: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              label: 'Nombre de usuario',
              controller: emailController,
              validator: (email) => Utils.validateInput(email),
              hasSuffixIcon: false,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: 'Contraseña',
              controller: passwordController,
              validator: (password) => Utils.validateInput(password),
              hasSuffixIcon: true,
            ),
            if (authState is AuthError)
              ErrorMessage(message: authState.message),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(authNotifierProvider.notifier)
                            .login(
                              emailController.text,
                              passwordController.text,
                            );
                      }

                      if (ref.read(authNotifierProvider) is AuthAuthenticated) {
                        if (context.mounted) {
                          context.goNamed('home');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Registrarse',
                    onPressed: () => context.pushNamed('register'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
