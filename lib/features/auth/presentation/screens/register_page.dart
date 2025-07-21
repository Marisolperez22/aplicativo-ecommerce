import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:fake_store_get_request/models/sing_up_request.dart';
import 'package:atomic_design_system/atoms/appbars/generic_app_bar.dart';
import 'package:atomic_design_system/atoms/text_fields/custom_text_field.dart';

import '../../../../core/utils/utils.dart';
import '../providers/sign_up_notifier.dart';
import '../../../../core/widgets/screen_widget.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpNotifierProvider);

    return ScreenWidget(
      appBar: GenericAppBar(title: 'Registro'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                label: 'Nombre de usuario',
                controller: _usernameController,
                validator: (userName) => Utils.validateInput(userName),
              ),
              SizedBox(height: 30),
              CustomTextField(
                label: 'Correo',
                controller: _emailController,
                validator: (correo) => Utils.validateEmail(correo),
              ),
              SizedBox(height: 30),
              CustomTextField(
                label: 'Contraseña',
                hasSuffixIcon: true,
                controller: _passwordController,
                validator: (password) => Utils.validateInput(password),
              ),
      
              const SizedBox(height: 30),
              if (state is SignUpLoading)
                const CircularProgressIndicator()
              else
                PrimaryButton(
                  text: 'Registrarse',
                  onPressed: () => _submitForm(state),
                ),
              if (state is SignUpError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(SignUpState state) {
    if (_formKey.currentState!.validate()) {
      final request = SignupRequest(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      ref.read(signUpNotifierProvider.notifier).signUp(request);

      if (state is SignUpRegistered) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registro exitoso')));
      }
    }
  }
}
