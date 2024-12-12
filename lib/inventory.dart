import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<dynamic> inventoryItems = [];

  @override
  void initState() {
    super.initState();
    fetchInventory();
  }

  // Función para obtener la información del inventario desde la API
  Future<void> fetchInventory() async {
    final response = await http.get(
      Uri.parse('http://18.117.224.244/api/inventory'), // Cambia la URL según corresponda
    );

    if (response.statusCode == 200) {
      setState(() {
        var data = json.decode(response.body);
        inventoryItems = data is List ? data : data['items'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar inventario')),
      );
    }
  }

  // Función para eliminar un producto con confirmación
  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar "$name"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final response = await http.delete(
                  Uri.parse('http://18.117.224.244/api/inventory/$id'),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    inventoryItems.removeWhere((item) => item['id'] == id);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto eliminado')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al eliminar producto')),
                  );
                }
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el formulario de agregar producto
  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                final category = categoryController.text;
                final quantity = int.tryParse(quantityController.text);
                final price = double.tryParse(priceController.text);

                if (name.isNotEmpty &&
                    category.isNotEmpty &&
                    quantity != null &&
                    price != null) {
                  final response = await http.post(
                    Uri.parse('http://18.117.224.244/api/inventory'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'name': name,
                      'category': category,
                      'quantity': quantity,
                      'price': price,
                    }),
                  );

                  if (response.statusCode == 200) {
                    fetchInventory();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Producto agregado')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al agregar producto')),
                    );
                  }
                }
              },
              child: const Text('Agregar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el formulario de editar producto
  void _showEditProductDialog(
    int id,
    String name,
    String category,
    int quantity,
    double price,
  ) {
    final nameController = TextEditingController(text: name);
    final categoryController = TextEditingController(text: category);
    final quantityController = TextEditingController(text: quantity.toString());
    final priceController = TextEditingController(text: price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedName = nameController.text;
                final updatedCategory = categoryController.text;
                final updatedQuantity = int.tryParse(quantityController.text);
                final updatedPrice = double.tryParse(priceController.text);

                if (updatedName.isNotEmpty &&
                    updatedCategory.isNotEmpty &&
                    updatedQuantity != null &&
                    updatedPrice != null) {
                  final response = await http.put(
                    Uri.parse('http://18.117.224.244/api/inventory/$id'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'name': updatedName,
                      'category': updatedCategory,
                      'quantity': updatedQuantity,
                      'price': updatedPrice,
                    }),
                  );

                  if (response.statusCode == 200) {
                    fetchInventory();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Producto actualizado')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al actualizar producto')),
                    );
                  }
                }
              },
              child: const Text('Actualizar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista de Inventarios',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: inventoryItems.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical, // Scroll vertical para la lista
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Scroll horizontal para las columnas
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Categoría')),
                            DataColumn(label: Text('Cantidad')),
                            DataColumn(label: Text('Precio')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: inventoryItems.map<DataRow>((item) {
                            return DataRow(cells: [
                              DataCell(Text(item['name'] ?? 'No disponible')),
                              DataCell(Text(item['category'] ?? 'No disponible')),
                              DataCell(Text('${item['quantity']}')),
                              DataCell(Text(
                                  '\$${double.tryParse(item['price']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}')),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditProductDialog(
                                          item['id'],
                                          item['name'],
                                          item['category'],
                                          item['quantity'],
                                          double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _confirmDelete(item['id'], item['name']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAddProductDialog,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
              child: const Text('Agregar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
