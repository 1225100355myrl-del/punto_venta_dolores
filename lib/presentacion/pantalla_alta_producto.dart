import 'package:flutter/material.dart';
import '../dominio/dinero.dart';
import '../dominio/producto.dart';
import 'caja_viewmodel.dart';

class PantallaAltaProducto extends StatefulWidget {
  final CajaViewModel vm;
  const PantallaAltaProducto({super.key, required this.vm});

  @override
  State<PantallaAltaProducto> createState() => _PantallaAltaProductoState();
}

class _PantallaAltaProductoState extends State<PantallaAltaProducto> {
  final _formKey = GlobalKey<FormState>();
  final _codigo = TextEditingController();
  final _nombre = TextEditingController();
  final _precio = TextEditingController();
  final _existencias = TextEditingController();

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final precioCentavos = pesosACentavos(_precio.text);
      if (precioCentavos <= 0) throw Exception('El precio debe ser mayor a 0');

      final p = Producto(
        codigo: _codigo.text.trim(),
        nombre: _nombre.text.trim(),
        precioCentavos: precioCentavos,
        existencias: int.parse(_existencias.text),
      );

      await widget.vm.productos.agregar(p);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codigo,
                decoration: const InputDecoration(labelText: 'Código'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _precio,
                decoration: const InputDecoration(labelText: 'Precio (\$)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _existencias,
                decoration: const InputDecoration(labelText: 'Existencias Iniciales'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _guardar,
                child: const Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}