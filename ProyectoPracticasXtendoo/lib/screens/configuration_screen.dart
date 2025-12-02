import 'package:flutter/material.dart';

import '../models/app_config.dart';
import '../services/config_service.dart';
import '../services/odoo_service.dart';
import 'home_screen.dart';

class ConfiguracionScreen extends StatefulWidget {
  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ConfigService _configService = ConfigService();

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarConfiguracion();
  }

  Future<void> _cargarConfiguracion() async {
    final config = await _configService.obtenerConfiguracion();
    if (config != null) {
      setState(() {
        _urlController.text = config.odooUrl;
        _telefonoController.text = config.numeroTelefono;
      });
    }
  }

  Future<void> _probarConexion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final config = AppConfig(
        odooUrl: _urlController.text.trim(),
        numeroTelefono: _telefonoController.text.trim(),
      );

      final odooService = OdooService(config);
      final conectado = await odooService.probarConexion();

      if (conectado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Conexión exitosa'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('No se pudo conectar');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✗ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _guardarConfiguracion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final config = AppConfig(
        odooUrl: _urlController.text.trim(),
        numeroTelefono: _telefonoController.text.trim(),
      );

      await _configService.guardarConfiguracion(config);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Configuración guardada')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            tooltip: 'Ir a Inicio',
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Ayuda'),
                  content: Text(
                      'Configure los parámetros de conexión a Odoo.\n\n'
                          'El número de teléfono se utilizará para identificar '
                          'su usuario en el sistema de gestión de jornadas.'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // SECCIÓN ODOO
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conexión Odoo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: 'URL de Odoo *',
                        hintText: 'https://miempresa.odoo.com',
                        prefixIcon: Icon(Icons.cloud),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La URL es obligatoria';
                        }
                        if (!value.startsWith('http')) {
                          return 'Debe comenzar con http:// o https://';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // SECCIÓN EMPLEADO
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Datos del Empleado',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _telefonoController,
                      decoration: InputDecoration(
                        labelText: 'Número de teléfono *',
                        hintText: '+34 600 123 456',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        helperText: 'Debe coincidir con el registrado en Odoo',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono es obligatorio';
                        }
                        final phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)]+$');
                        if (!phoneRegex.hasMatch(value)) {
                          return 'Formato de teléfono inválido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // BOTONES
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _cargando ? null : _probarConexion,
                    icon: Icon(Icons.wifi_find),
                    label: Text('Probar Conexión'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _cargando ? null : _guardarConfiguracion,
                    icon: _cargando
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                        : Icon(Icons.save),
                    label: Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Botón de reseteo
            TextButton.icon(
              onPressed: () async {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('¿Borrar configuración?'),
                    content: Text(
                      'Se eliminarán todos los parámetros guardados.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Borrar'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmar == true) {
                  await _configService.limpiarConfiguracion();
                  setState(() {
                    _urlController.clear();
                    _telefonoController.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Configuración eliminada')),
                  );
                }
              },
              icon: Icon(Icons.delete_outline, color: Colors.red),
              label: Text('Borrar configuración'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
