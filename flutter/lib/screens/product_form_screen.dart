import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? product; // Producto opcional (para editar)

  ProductFormScreen({this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product!['nombre'] ?? "";
      descriptionController.text = widget.product!['descripcion'] ?? "";
      priceController.text = widget.product!['precio']?.toString() ?? "";
    }
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Recupera el token almacenado
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url =
        widget.product == null
            ? 'http://10.0.2.2:3000/productos' // Para agregar producto
            : 'http://10.0.2.2:3000/productos/${widget.product!['_id']}'; // Para editar producto

    // Configura los headers con el token de autenticación
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      "nombre": nameController.text,
      "descripcion": descriptionController.text,
      "precio": double.tryParse(priceController.text) ?? 0,
    });

    final response =
        widget.product == null
            ? await http.post(Uri.parse(url), headers: headers, body: body)
            : await http.put(Uri.parse(url), headers: headers, body: body);

    setState(() => _isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product == null
                ? "Producto agregado con éxito"
                : "Producto actualizado con éxito",
          ),
        ),
      );
      Navigator.pop(context, true); // Regresa a la lista y actualiza
    } else {
      // Para ayudar a depurar, imprime la respuesta en consola
      print("Status Code: ${response.statusCode}");
      print("Response body: ${response.body}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar el producto")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? "Agregar Producto" : "Editar Producto",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nombre"),
                validator:
                    (value) => value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Descripción"),
                maxLines: 3,
                validator:
                    (value) =>
                        value!.isEmpty ? "Ingrese una descripción" : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Precio"),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? "Ingrese un precio" : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: saveProduct,
                    child: Text(
                      widget.product == null
                          ? "Agregar Producto"
                          : "Guardar Cambios",
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
