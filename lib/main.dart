import 'package:flutter/material.dart';
import 'login.dart'; // Asegúrate de que la ruta al archivo login.dart sea correcta
import 'dashboard_page.dart'; // Importa la página del Dashboard
import 'inventory.dart'; // Importa la página de inventario
import 'components.dart'; // Importa la página de componentes
import 'pc_builds.dart'; // Importa la página de PC ensambladas
import 'support.dart'; // Importa la página de soporte

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ensamblajes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[900]!),
        useMaterial3: true,
      ),
      home: const WelcomePage(), // Página de bienvenida
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/inventory': (context) => const InventoryPage(),
        //'/components': (context) => const ComponentsPage(),
        //'/pc-ensambladas': (context) => const PcBuildsPage(),
        //'/soporte-tecnico': (context) => const SupportPage(),
      },
    );
  }
}

// Pantalla de bienvenida
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/inicio.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de bienvenida
                Image.asset(
                  'assets/computer.png', // Ruta de la imagen de bienvenida
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  '¡Bienvenido a Ensamblajes AIGG!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Color blanco para el texto
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla de login
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Inicio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
