import 'package:flutter/material.dart';
import '../config/configuracion_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Jornadas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConfiguracionScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: const Center(
        child: Text("Pantalla principal"),
      ),
    );
  }
}
