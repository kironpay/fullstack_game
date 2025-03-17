import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Nueva pantalla de inicio de sesión
import 'screens/product_list_screen.dart'; // Pantalla de productos
import 'screens/user_list_screen.dart'; // Pantalla de usuarios

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Usuarios y Productos',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/usuarios': (context) => UserListScreen(),
        '/productos': (context) => ProductListScreen(),
      },
    );
  }
}
