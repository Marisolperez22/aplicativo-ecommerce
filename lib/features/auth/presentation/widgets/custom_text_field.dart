import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool? hasSuffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.validator,
    required this.label,
    required this.controller,
    this.hasSuffixIcon = false, 
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: (widget.hasSuffixIcon ?? false) && !_showPassword,
      decoration: InputDecoration(
        filled: true,
        labelText: widget.label,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
        suffixIcon:
            (widget.hasSuffixIcon ?? false)
                ? IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed:
                      () => setState(() => _showPassword = !_showPassword),
                )
                : null, 
      ),
    );
  }
}
