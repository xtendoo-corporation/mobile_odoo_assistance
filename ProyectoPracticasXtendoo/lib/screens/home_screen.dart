import 'package:flutter/material.dart';
import '../services/config_service.dart';
import 'configuration_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final ConfigService _configService = ConfigService();
  bool _configurada = false;

  @override
  void initState() {
    super.initState();
    _verificarConfiguracion();
  }

  Future<void> _verificarConfiguracion() async {
    bool configurada = await _configService.estaConfigurado();
    setState(() {
      _configurada = configurada;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Jornadas'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfiguracionScreen(),
                ),
              );
            },
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              size: 80,
              color: Colors.deepPurple,
            ),
            SizedBox(height: 20),
            Text(
              'Pantalla principal de la app',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 40),
            // BOTÓN REGISTRAR HORA
            if (_configurada)...[
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hora registrada!')),
                  );
                },
                icon: Icon(Icons.fingerprint),
                label: Text('Registrar hora entrada'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              ElevatedButton.icon(
              onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hora registrada!')),
              );
              },
              icon: Icon(Icons.fingerprint),
              label: Text('Registrar hora salida'),
              style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              )
            ]else
              Text('Configura Odoo primero para registrar hora'),

            SizedBox(height: 20),


            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfiguracionScreen(),
                  ),
                );
              },
              icon: Icon(Icons.settings),
              label: Text('Ir a Configuración'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
