// exemplo_01_minimo_inicio.dart
// Ponto de partida: um Stream emitindo de segundo em segundo, e a tela imóvel.
//
// Rode e olhe as duas coisas ao mesmo tempo:
//
//   o console  ->  "o stream emitiu: 0", "1", "2"  (um por segundo)
//   a tela     ->  "Aguardando o primeiro tick...", para sempre
//
// ! Os eventos CHEGAM. O stream funciona.
//
// ? Você já resolveu esse mesmo problema uma aula atrás, com um Future. A
// ? diferença é que um Future entrega UM valor e acaba; este stream entrega
// ? VÁRIOS, ao longo do tempo.
// ?
// ?   **existe um widget irmão do FutureBuilder para isso?**
// ?
// ? Existe, e a assinatura é quase a mesma. Repare também no lugar do stream:
// ? campo do `State`, criado uma vez — pelo mesmo motivo do Future.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaContador()));

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  // * O Stream é guardado num campo e criado UMA vez, no initState.
  // Se ele nascesse dentro do build, cada rebuild criaria um novo e o contador
  // reiniciaria do zero (essa é a armadilha do exemplo 05).
  late final Stream<int> _ticks;

  @override
  void initState() {
    super.initState();
    // Emite 0, 1, 2, 3... um por segundo, para sempre.
    _ticks = Stream.periodic(const Duration(seconds: 1), (count) => count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador ao vivo')),
      body: Center(
        child: StreamBuilder(
          stream: _ticks,
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData) {
              return const Text('Aguardando o primeiro tick...');
            }
            return Text('Segundos: ${asyncSnapshot.data}');
          },
        ),
      ),
    );
  }
}
