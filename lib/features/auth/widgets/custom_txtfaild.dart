import 'package:flutter/material.dart';
import 'package:shaqti/core/theme/app_colors.dart';

class CustomTxtfaild extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Icon icon;
  final String? Function(String?)? validator;
  final bool isPassword;
  
  const CustomTxtfaild({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    this.isPassword = false,
  });

  @override
  State<CustomTxtfaild> createState() => _CustomTxtfaildState();
}

class _CustomTxtfaildState extends State<CustomTxtfaild> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: AppColors.black),
      enabled: true,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.isPassword && _isObscured,
      cursorColor: AppColors.turquoise,
      cursorHeight: 20,
      decoration: InputDecoration(
        enabled: true,
        prefixIcon: widget.icon,
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _isObscured ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                onPressed: () => setState(() => _isObscured = !_isObscured),
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
            : null,
        hintText: widget.hint,
        fillColor: AppColors.turquoise,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: AppColors.turquoise),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: AppColors.turquoise),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade900),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}
