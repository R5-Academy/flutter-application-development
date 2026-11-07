// exemplo_04_hide_current_inicio.dart
// Ponto de partida: um botão que mostra um SnackBar numerado a cada toque.
//
// ! Clique **rápido, cinco vezes seguidas**. Depois espere.
// !
// ! As cinco mensagens não se substituem: elas **enfileiram**. A #1 fica os
// ! quatro segundos dela, depois entra a #2, depois a #3... Medido: cada
// ! mensagem ocupa ~4,6 s do rodízio (4 s de `duration` + as animações de
// ! entrada e saída), então cinco cliques viram mais de **vinte segundos**
// ! vendo avisos velhos passarem, um de cada vez.
//
// ! Num app real isso acontece o tempo todo: a pessoa favorita três itens
// ! seguidos, ou toca duas vezes num botão achando que não pegou. E o app passa
// ! a mostrar o passado.
//
// ? O `ScaffoldMessenger` mantém uma **fila**. Como dizer a ele que só a
// ? mensagem mais recente importa?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaFila()));

class TelaFila extends StatefulWidget {
  const TelaFila({super.key});

  @override
  State<TelaFila> createState() => _TelaFilaState();
}

class _TelaFilaState extends State<TelaFila> {
  int _contador = 0;

  void _mostrar() {
    _contador++;
    // ! Cada clique enfileira mais um.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mensagem #$_contador (enfileirada)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fila do ScaffoldMessenger')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Text('Clique rápido várias vezes'),
            FilledButton(
              onPressed: _mostrar,
              child: const Text('Mostrar mensagem'),
            ),
          ],
        ),
      ),
    );
  }
}
