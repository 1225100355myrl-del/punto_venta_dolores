import 'excepciones.dart';
import 'producto.dart';

class LineaCarrito {
  final Producto producto;
  int cantidad;

  LineaCarrito(this.producto, this.cantidad);

  int get importeCentavos => producto.precioCentavos * cantidad;
}

class Carrito {
  final int tasaIva;
  final Map<String, LineaCarrito> _lineas = {};
  int _descuentoPorcentaje = 0;

  Carrito({this.tasaIva = 16});

  List<LineaCarrito> get lineas => _lineas.values.toList();
  bool get estaVacio => _lineas.isEmpty;

  void agregar(Producto p, {int cantidad = 1}) {
    final actual = _lineas[p.codigo]?.cantidad ?? 0;
    if (actual + cantidad > p.existencias) {
      throw ExistenciasInsuficientesException(p.nombre, p.existencias);
    }
    if (_lineas.containsKey(p.codigo)) {
      _lineas[p.codigo]!.cantidad += cantidad;
    } else {
      _lineas[p.codigo] = LineaCarrito(p, cantidad);
    }
  }

  void quitar(String codigo) => _lineas.remove(codigo);
  void vaciar() => _lineas.clear();

  void aplicarDescuento(int porcentaje) {
    if (porcentaje < 0 || porcentaje > 100) {
      throw FormatException('Porcentaje de descuento inválido');
    }
    _descuentoPorcentaje = porcentaje;
  }

  int get totalBrutoCentavos =>
      _lineas.values.fold(0, (sum, l) => sum + l.importeCentavos);

  int get montoDescuentoCentavos =>
      (totalBrutoCentavos * _descuentoPorcentaje) ~/ 100;

  int get totalCentavos => totalBrutoCentavos - montoDescuentoCentavos;

  int get ivaCentavos =>
      (totalCentavos * tasaIva + (100 + tasaIva) ~/ 2) ~/ (100 + tasaIva);

  int get subtotalCentavos => totalCentavos - ivaCentavos;

  int cambio(int pagoCentavos) {
    if (estaVacio) throw CarritoVacioException();
    if (pagoCentavos < totalCentavos) {
      throw PagoInsuficienteException(totalCentavos - pagoCentavos);
    }
    return pagoCentavos - totalCentavos;
  }
}