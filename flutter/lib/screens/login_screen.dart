import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String apiUrl = "http://10.0.2.2:3000/auth/login"; // URL de la API

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "correo": correoController.text.trim(), // 🛠 Corregido de "email" a "correo"
          "password": passwordController.text.trim(),
        }),
      );

      print("Enviando datos: ${correoController.text}, ${passwordController.text}"); // Debug

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Inicio de sesión exitoso")),
          );

          // Redirigir a la pantalla de productos
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProductListScreen()),
          );
        }
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _errorMessage = data["message"] ?? "Credenciales incorrectas";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión con el servidor";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: correoController,
              decoration: InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: login,
              child: Text("Iniciar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
