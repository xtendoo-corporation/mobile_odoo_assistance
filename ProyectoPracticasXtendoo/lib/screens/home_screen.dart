import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'configuration_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Jornadas'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfiguracionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Pantalla principal de la app'),
      ),
    );
  }
}