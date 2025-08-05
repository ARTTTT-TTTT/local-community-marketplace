import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isPasswordVisible,
          enabled: enabled,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            suffixIcon: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Transform.scale(
                  scaleX: isPasswordVisible
                      ? 1.0
                      : -1.0, // Mirror the visibility_off icon
                  child: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off_outlined,
                    key: ValueKey(isPasswordVisible),
                    color: isPasswordVisible
                        ? Colors.blue.shade600
                        : Colors.grey.shade600,
                    size: 22,
                  ),
                ),
              ),
              onPressed: onVisibilityToggle,
              splashRadius: 20,
              tooltip: isPasswordVisible ? 'ซ่อนรหัสผ่าน' : 'แสดงรหัสผ่าน',
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: false,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0, // Remove horizontal padding for cleaner underline
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
