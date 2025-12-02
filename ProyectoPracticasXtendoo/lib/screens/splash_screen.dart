import 'package:flutter/material.dart';
import '../services/config_service.dart';
import 'configuration_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ConfigService _configService = ConfigService();

  @override
  void initState() {
    super.initState();
    _verificarConfiguracion();
  }

  Future<void> _verificarConfiguracion() async {
    await Future.delayed(Duration(seconds: 1));
    final configurado = await _configService.estaConfigurado();
    if (configurado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConfiguracionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
