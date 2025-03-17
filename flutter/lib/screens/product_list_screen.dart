import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Obtener productos desde la API
  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/productos'),
      );

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
        });
      } else {
        print("Error en la respuesta: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al conectar con la API: $e");
    }

    setState(() => isLoading = false);
  }

  // Eliminar producto con confirmación
  Future<void> deleteProduct(String id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Eliminar Producto"),
            content: Text("¿Seguro que deseas eliminar este producto?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmDelete) {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/productos/$id'),
      );

      if (response.statusCode == 200) {
        fetchProducts();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Producto eliminado")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al eliminar producto")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchProducts, // Botón de actualizar
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator()) // Indicador de carga
              : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return ListTile(
                    title: Text(product['nombre']),
                    subtitle: Text("\$${product['precio']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ProductFormScreen(product: product),
                                ),
                              ).then((_) => fetchProducts()),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteProduct(product['_id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductFormScreen()),
            ).then((_) => fetchProducts()),
      ),
    );
  }
}
