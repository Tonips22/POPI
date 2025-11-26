import 'dart:math';

class GameControllerOrdenar {
  late List<int> numerosDesordenados;
  late List<int?> numerosOrdenados;
  late int min;
  late int max;
  late int cantidad;

  GameControllerOrdenar({
    required this.min,
    required this.max,
    required this.cantidad,
  }) {
    generarNuevaSecuencia();
  }

  /// Genera una nueva secuencia aleatoria
  void generarNuevaSecuencia() {
    final random = Random();

    // Generar lista aleatoria dentro del rango
    List<int> lista = List.generate(
      cantidad,
          (_) => min + random.nextInt(max - min + 1),
    );

    // Mezclar la lista
    lista.shuffle();

    numerosDesordenados = List.from(lista);

    // Lista donde el jugador colocará los números (vacías)
    numerosOrdenados = List.filled(cantidad, null);
  }

  /// Verifica si todos los números fueron colocados correctamente
  bool secuenciaCorrecta() {
    // Si aún quedan null, no está completa
    if (numerosOrdenados.contains(null)) return false;

    for (int i = 0; i < numerosOrdenados.length - 1; i++) {
      if (numerosOrdenados[i]! > numerosOrdenados[i + 1]!) {
        return false;
      }
    }
    return true;
  }

  /// Colocar un número en una posición inferior
  bool colocarNumero(int numero, int posicion) {
    if (posicion < 0 || posicion >= cantidad) return false;

    // Evita sobrescribir casillas ya llenas
    if (numerosOrdenados[posicion] != null) return false;

    numerosOrdenados[posicion] = numero;
    numerosDesordenados.remove(numero);

    return true;
  }

  /// Quitar un número ya colocado (por si el jugador se equivoca)
  void quitarNumero(int posicion) {
    if (numerosOrdenados[posicion] == null) return;

    int numero = numerosOrdenados[posicion]!;
    numerosOrdenados[posicion] = null;
    numerosDesordenados.add(numero);
  }

  /// Reinicia la partida generando nueva secuencia
  void reiniciar() {
    generarNuevaSecuencia();
  }
}
