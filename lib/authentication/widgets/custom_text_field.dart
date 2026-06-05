import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? errorText;
  final bool autoTrim;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.autoTrim = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white),
          inputFormatters: [
            // Nếu là email, chặn hoàn toàn dấu cách
            if (widget.keyboardType == TextInputType.emailAddress)
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          onChanged: (value) {
            // Có thể thực hiện trim ở đây nếu muốn "tự động" hoàn toàn
            // Nhưng tốt nhất nên trim ở ViewModel để tránh lỗi nhảy con trỏ
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.hex1C1C1C,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: widget.errorText != null
                  ? const BorderSide(color: Colors.redAccent, width: 1)
                  : BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white38,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : null,
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
