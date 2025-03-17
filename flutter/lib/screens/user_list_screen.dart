import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> usuarios = [];
  bool isLoading = false; // Indicador de carga

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    setState(() => isLoading = true);
    try {
      final data = await apiService.getUsuarios();
      setState(() {
        usuarios = data;
      });
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
    setState(() => isLoading = false);
  }

  Future<void> eliminarUsuario(String id) async {
    try {
      await apiService.eliminarUsuario(id);
      cargarUsuarios(); // Recargar la lista después de eliminar
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuarios"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: cargarUsuarios, // Botón de refrescar
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator()) // Indicador de carga
              : ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return ListTile(
                    title: Text(usuario["nombre"]),
                    subtitle: Text(usuario["correo"]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => eliminarUsuario(usuario["_id"]),
                    ),
                  );
                },
              ),
    );
  }
}
