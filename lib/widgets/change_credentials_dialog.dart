import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateLoginDataDialog extends StatefulWidget {
  final Function(String, String) onSave;
  final VoidCallback onLogout;

  const UpdateLoginDataDialog({
    super.key,
    required this.onSave,
    required this.onLogout,
  });

  @override
  _UpdateLoginDataDialogState createState() => _UpdateLoginDataDialogState();
}

class _UpdateLoginDataDialogState extends State<UpdateLoginDataDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  String _generatePassword() {
    const length = 8;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  String _generateEmail() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    final rand = Random();
    return '${letters[rand.nextInt(letters.length)]}${letters[rand.nextInt(letters.length)]}'
        '${numbers[rand.nextInt(numbers.length)]}${numbers[rand.nextInt(numbers.length)]}'
        '@futbolabarroteraH.com';
  }

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _copyToClipboard() {
    final text =
        'Correo: ${_emailController.text}\nContraseña: ${_passwordController.text}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos copiados al portapapeles')),
    );
  }

  void _clearEmail() {
    setState(() {
      _emailController.clear();
    });
  }

  void _clearPassword() {
    setState(() {
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Actualizar datos de inicio de sesión',
          style: GoogleFonts.mulish()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Correo electrónico',
                  ),
                  style: GoogleFonts.mulish(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _clearEmail();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: _emailController.text.isNotEmpty
                      ? null
                      : () {
                          setState(() {
                            _emailController.text = _generateEmail();
                          });
                        },
                  child: Text('Generar correo',
                      style: GoogleFonts.mulish(fontSize: 12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: const InputDecoration(
                    hintText: 'Contraseña',
                  ),
                  style: GoogleFonts.mulish(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: _togglePasswordView,
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _clearPassword();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: _passwordController.text.isNotEmpty
                      ? null
                      : () {
                          setState(() {
                            _passwordController.text = _generatePassword();
                          });
                        },
                  child: Text('Generar contraseña',
                      style: GoogleFonts.mulish(fontSize: 12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _copyToClipboard,
              icon: const Icon(Icons.copy),
              label: Text('Copiar datos actualizados',
                  style: GoogleFonts.mulish()),
            ),
            const SizedBox(height: 10),
            Text(
              'Se cerrará sesión al guardar los datos modificados. Recuerda tomar una captura de pantalla o copiar los nuevos datos.',
              style: GoogleFonts.mulish(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cerrar', style: GoogleFonts.mulish()),
        ),
        TextButton(
          onPressed: () {
            final text =
                'Correo: ${_emailController.text}\nContraseña: ${_passwordController.text}';
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos copiados al portapapeles')),
            );
            Navigator.of(context).pop();
            widget.onSave(_emailController.text, _passwordController.text);
            widget.onLogout();
          },
          child: Text('Guardar y salir', style: GoogleFonts.mulish()),
        ),
      ],
    );
  }
}

void showUpdateLoginDataDialog({
  required BuildContext context,
  required Function(String, String) onSave,
  required VoidCallback onLogout,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UpdateLoginDataDialog(onSave: onSave, onLogout: onLogout);
    },
  );
}
