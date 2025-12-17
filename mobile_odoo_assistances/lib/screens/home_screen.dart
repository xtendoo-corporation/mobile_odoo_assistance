import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/location_helper.dart';
import 'settings_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInside = false;
  final ApiService _apiService = ApiService();
  bool _sending = false;
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }
  Future<void> _fetchOdooStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final telefono = prefs.getString('telefono') ?? '';
    final url = prefs.getString('url') ?? '';
    final pin = prefs.getString('pin') ?? '';

    if (telefono.isEmpty || url.isEmpty || pin.isEmpty) {
      throw Exception('Configuración incompleta');
    }

    final currentStatus = await _apiService.getEmployeeStatus(
      baseUrl: url,
      telefono: telefono,
      pin: pin,
    );

    // Actualizar estado local con el estado del servidor
    await _saveState(currentStatus);

    if (mounted) {
      setState(() {
        isInside = currentStatus;
      });
    }
  }
  Future<void> _loadInitialState() async {
    setState(() {
      _initialLoading = true;
    });

    try {
      await _fetchOdooStatus();
    } catch (e) {
      print('Error al cargar estado inicial: $e');
      // Si falla, intenta cargar el estado local como fallback
      await _loadLocalState();
    } finally {
      setState(() {
        _initialLoading = false;
      });
    }
  }

  Future<void> _loadLocalState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isInside = prefs.getBool('isInside') ?? false;
    });
  }


  Future<void> _saveState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isInside', value);
  }


  Future<void> _onFicharPressed() async {
    setState(() {
      _sending = true;
    });

    final estadoAnterior = isInside; // Guardar estado anterior por si falla

    try {
      // 1) Obtener posición
      final posicion = await LocationHelper.getCurrentPosition();

      // 2) Leer configuración
      final prefs = await SharedPreferences.getInstance();
      final telefono = prefs.getString('telefono') ?? '';
      final url = prefs.getString('url') ?? '';
      final pin = prefs.getString('pin') ?? '';

      if (telefono.isEmpty || url.isEmpty || pin.isEmpty) {
        throw Exception('Faltan datos en configuración (telefono/url/pin)');
      }

      // 3) Calcular nuevo estado (el opuesto al actual)
      final nuevoEstado = !isInside;

      // 4) Enviar marcaje a Odoo
      final response = await _apiService.enviarMarcaje(
        baseUrl: url,
        telefono: telefono,
        pin: pin,
        entrando: nuevoEstado,
        posicion: posicion,
      );

      // 5) Solo si la respuesta es exitosa, consultar el estado REAL desde Odoo
      await _fetchOdooStatus();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Marcaje enviado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Si falla, restaurar el estado anterior
      setState(() {
        isInside = estadoAnterior;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/top_left_logo.png',
            width: 36,
            height: 36,
            fit: BoxFit.contain,
          ),
        ),
        title: const Text('Control Horario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              // Navegar a settings y recargar estado al volver
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              // Recargar el estado desde el servidor al volver de settings
              _loadInitialState();
            },
          ),
        ],
      ),
      body: Center(
        child: _initialLoading || _sending
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _onFicharPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: isInside ? Colors.red : Colors.green,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInside) ...[
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.door_front_door,
                      color: Colors.white,
                      size: 28,
                    ),
                  ] else ...[
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                  const SizedBox(width: 12),
                  Text(
                    isInside ? 'Fichar Salida' : 'Fichar Entrada',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
