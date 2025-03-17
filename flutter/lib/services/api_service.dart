import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://fullstack-game-github.onrender.com";

  // Obtener todos los usuarios
  Future<List<dynamic>> getUsuarios() async {
    final response = await http.get(Uri.parse("$baseUrl/usuarios"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener usuarios");
    }
  }

  // Crear usuario
  Future<void> crearUsuario(String nombre, String correo) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuarios"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"nombre": nombre, "correo": correo}),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear usuario");
    }
  }

  // Modificar usuario
  Future<void> actualizarUsuario(
    String id,
    String nombre,
    String correo,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/usuarios/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"nombre": nombre, "correo": correo}),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar usuario");
    }
  }

  // Eliminar usuario
  Future<void> eliminarUsuario(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/usuarios/$id"));

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar usuario");
    }
  }
}
