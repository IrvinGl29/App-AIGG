import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Para realizar la solicitud HTTP
import 'login.dart'; // Asegúrate de importar la página del Login

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Función para cerrar sesión
  Future<void> _logout(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.168.100.53:8080/api/auth/logout'), // Cambia la URL por la de tu API de logout
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Si el servidor responde correctamente (cierre de sesión exitoso)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      // Si ocurre un error en la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cerrar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido a Ensamblajes',
              style: TextStyle(color: Colors.white),
            ),
            const Spacer(),
            // Imagen a la derecha que cierra sesión al hacer clic
            GestureDetector(
              onTap: () => _logout(context), // Llama a la función _logout al hacer clic
              child: Image.asset(
                'assets/cerrar.png',
                width: 50,
                height: 50,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF003366),
        leading: SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Navegacion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inventory');
                    },
                    child: const Text('Inventario'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/components');
                    },
                    child: const Text('Componentes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pc-ensambladas');
                    },
                    child: const Text('PC-Ensambladas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/soporte-tecnico');
                    },
                    child: const Text('Soporte Técnico'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
