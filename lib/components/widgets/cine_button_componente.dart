import 'package:flutter/material.dart';

class CineButtonComponente extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;

  const CineButtonComponente({
    super.key,
    required this.text,
    required this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ocupa toda a largura
      height: 50, // Altura original
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // 🔴 padrão
          foregroundColor: Colors.white, // ⚪ padrão
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Bordas originais
          ),
          elevation: 2, // Sombra original
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
