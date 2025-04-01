import 'package:chat_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    this.errorText,
    required this.passwordController,
  });

  final String label;
  final String? errorText;
  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      decoration: InputDecoration(
        label: Text(widget.label),
        errorText: widget.errorText,
        suffixIcon: InkWell(
          onTap: () => setState(() {
            _isObscure = !_isObscure;
          }),
          child: Icon(
            Icons.remove_red_eye_outlined,
            color: widget.errorText == null ? AppColors.green : Colors.red,
          ),
        ),
      ),
      obscureText: _isObscure,
    );
  }
}
