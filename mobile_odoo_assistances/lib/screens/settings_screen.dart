import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});


  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController pinController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }


  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();


    phoneController.text = prefs.getString('telefono') ?? '';
    urlController.text = prefs.getString('url') ?? '';
    pinController.text = prefs.getString('pin') ?? '';
  }


  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();


    await prefs.setString('telefono', phoneController.text);
    await prefs.setString('url', urlController.text);
    await prefs.setString('pin', pinController.text);


    if (!mounted) return;
    // Mostrar mensaje
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configuración guardada')));
    // Volver a la pantalla anterior (HomeScreen)
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'URL Base (ej: https://mi-odoo/... )'),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinController,
              decoration: const InputDecoration(labelText: 'PIN'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}