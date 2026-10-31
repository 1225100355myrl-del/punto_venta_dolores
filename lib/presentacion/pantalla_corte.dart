import 'package:flutter/material.dart';
import '../datos/repositorio_ventas.dart';
import '../dominio/dinero.dart';
import '../dominio/venta.dart';

class PantallaCorte extends StatelessWidget {
  final RepositorioVentas ventas;

  const PantallaCorte({super.key, required this.ventas});

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Corte del Día')),
      body: FutureBuilder(
        future: Future.wait([
          ventas.corteDelDia(hoy),
          ventas.masVendidos(limite: 5),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ResumenDia resumen = snapshot.data![0];
          final top5 = (snapshot.data![1] as List)
              .map((e) => Map<String, Object?>.from(e))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Ventas Realizadas: ${resumen.numeroVentas}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Total Cobrado: ${formatearPesos(resumen.totalCentavos)}', style: Theme.of(context).textTheme.headlineSmall),
                      Text('IVA Desglosado: ${formatearPesos(resumen.ivaCentavos)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Top 5 Más Vendidos', style: Theme.of(context).textTheme.titleLarge),
              const Divider(),
              for (final item in top5)
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(item['nombre'] as String),
                  trailing: Text('${item['unidades']} unidades'),
                ),
            ],
          );
        },
      ),
    );
  }
}