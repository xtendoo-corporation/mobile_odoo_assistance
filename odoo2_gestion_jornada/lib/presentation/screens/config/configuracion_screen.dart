import 'package:flutter/material.dart';
import '../../../config/config_service.dart';
import '../../../config/app_config.dart';
import '../../../data/services/odoo/odoo_service.dart';

class ConfiguracionScreen extends StatefulWidget {
  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final cfgService = ConfigService();
  final odoo = OdooService();
  final telefonoCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool cargando = false;
  int? empleadoId;
  String? nombreEmpleado;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final cfg = await cfgService.obtenerConfiguracion();
    if (cfg != null) {
      telefonoCtrl.text = cfg.numeroTelefono;
      empleadoId = cfg.empleadoId;
      nombreEmpleado = cfg.nombreEmpleado;
      setState(() {});
    }
  }

  Future<void> buscarEmpleado() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    final emp = await odoo.buscarEmpleadoPorTelefono(
      telefonoCtrl.text.trim(),
    );

    setState(() => cargando = false);

    if (emp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se encontró empleado"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    empleadoId = emp["id"];
    nombreEmpleado = emp["name"];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Empleado: ${nombreEmpleado!}"),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {});
  }

  Future<void> guardar() async {
    if (empleadoId == null) return;

    final config = AppConfig(
      numeroTelefono: telefonoCtrl.text.trim(),
      empleadoId: empleadoId,
      nombreEmpleado: nombreEmpleado,
    );

    await cfgService.guardarConfiguracion(config);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración Inicial")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: telefonoCtrl,
              decoration: const InputDecoration(
                labelText: "Número de teléfono",
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Campo obligatorio";
                return null;
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: cargando ? null : buscarEmpleado,
              child: cargando
                  ? const CircularProgressIndicator()
                  : const Text("Buscar empleado"),
            ),

            if (nombreEmpleado != null) ...[
              const SizedBox(height: 16),
              Text("Empleado encontrado: $nombreEmpleado (ID: $empleadoId)")
            ],

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: empleadoId != null ? guardar : null,
              icon: const Icon(Icons.save),
              label: const Text("Guardar y continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
