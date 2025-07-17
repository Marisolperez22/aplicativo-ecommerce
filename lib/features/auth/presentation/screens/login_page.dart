import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/atoms/buttons/primary_button.dart';

import '../providers/auth_notifier.dart';
import '../widgets/custom_text_field.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/error_message.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 200),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(247, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
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
                  
                                  if (ref.read(authNotifierProvider)
                                      is AuthAuthenticated) {
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
