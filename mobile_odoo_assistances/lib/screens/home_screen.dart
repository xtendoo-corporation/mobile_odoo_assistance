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
// 1) Guardar nuevo estado localmente
      await _saveState(nueva);
      setState(() {
        isInside = nueva;
      });

// 2) Obtener posición (pide permisos si es necesario)
      final posicion = await LocationHelper.getCurrentPosition();

// 3) Leer datos de configuración
      final prefs = await SharedPreferences.getInstance();
      final telefono = prefs.getString('telefono') ?? '';
      final url = prefs.getString('url') ?? '';
      final pin = prefs.getString('pin') ?? '';

      if (telefono.isEmpty || url.isEmpty || pin.isEmpty) {
        throw Exception('Faltan datos en configuración (telefono/url/pin)');
      }

// 4) Enviar al ApiService
      await _apiService.enviarMarcaje(
        baseUrl: url,
        telefono: telefono,
        pin: pin,
        entrando: nueva,
        posicion: posicion,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marcaje enviado correctamente')));
    } catch (e) {
// En caso de error, revertimos el estado guardado localmente y mostramos el error
      await _saveState(isInside); // mantener el anterior
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
            : ElevatedButton(
          onPressed: _onFicharPressed,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
          child: Text(isInside ? 'Fichar / Salir' : 'Fichar / Entrar', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

