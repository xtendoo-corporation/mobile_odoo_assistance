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


  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
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

    final nueva = !isInside;

    try {
      // 1) Obtener posición PRIMERO (antes de cambiar estado)
      final posicion = await LocationHelper.getCurrentPosition();

      // 2) Leer datos de configuración
      final prefs = await SharedPreferences.getInstance();
      final telefono = prefs.getString('telefono') ?? '';
      final url = prefs.getString('url') ?? '';
      final pin = prefs.getString('pin') ?? '';

      if (telefono.isEmpty || url.isEmpty || pin.isEmpty) {
        throw Exception('Faltan datos en configuración (telefono/url/pin)');
      }

      // 3) Enviar marcaje y esperar respuesta
      final response = await _apiService.enviarMarcaje(
        baseUrl: url,
        telefono: telefono,
        pin: pin,
        entrando: nueva,
        posicion: posicion,
      );

      // 4) SOLO si fue exitoso, guardar el nuevo estado
      await _saveState(nueva);
      setState(() {
        isInside = nueva;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Marcaje enviado correctamente'))
      );
    } catch (e) {
      // NO cambiar el estado si hubo error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _sending
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen encima del botón
            Image.asset(
              'assets/images/app_icon.png', // Cambia por el nombre de tu imagen
              width: 200, // Ajusta el tamaño según necesites
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30), // Espacio entre imagen y botón
            // Botón existente
            ElevatedButton(
              onPressed: _onFicharPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: isInside ? Colors.green : Colors.red,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInside) ...[  // ✅ Cambiado: si está dentro, mostrar salida
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.door_front_door,
                      color: Colors.white,
                      size: 28,
                    ),
                  ] else ...[  // ✅ Si está fuera, mostrar entrada
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                  const SizedBox(width: 12),
                  Text(
                    isInside ? 'Fichar Salida' : 'Fichar Entrada',  // ✅ Corregido
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
