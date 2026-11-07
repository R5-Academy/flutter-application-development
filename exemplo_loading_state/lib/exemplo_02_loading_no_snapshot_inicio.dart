// exemplo_02_loading_no_snapshot_inicio.dart
// Ponto de partida: o indicador saiu do lugar fixo do exemplo anterior e a tela
// passou a depender de um Future.
//
// Rode: por dois segundos a tela fica **em branco**, e então a mensagem
// aparece. Nada gira, nada avisa.
//
// ? O `builder` já roda durante a espera — ele só não tem nada para mostrar,
// ? porque `snapshot.data` ainda é null e o `??` devolve string vazia.
// ?
// ?   **em que ramo do snapshot o indicador encaixa?**
// ?
// ? E, junto com ela, uma segunda pergunta que só aparece quando a tela
// ? RECARREGA: durante a segunda busca, o snapshot volta a `waiting` — mas
// ? desta vez com o dado antigo ainda dentro dele.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaMensagem()));

// Simula a busca de uma mensagem no servidor (2s de espera).
Future<String> buscarMensagem() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Olá, bem-vindo de volta!';
}

class TelaMensagem extends StatefulWidget {
  const TelaMensagem({super.key});

  @override
  State<TelaMensagem> createState() => _TelaMensagemState();
}

class _TelaMensagemState extends State<TelaMensagem> {
  // Future guardado no State (criado uma vez), como visto na aula de FutureBuilder.
  late final Future<String> _futureMensagem = buscarMensagem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading no snapshot')),
      body: Center(
        child: FutureBuilder<String>(
          future: _futureMensagem,
          builder: (context, snapshot) {
            // Terminou: mostramos o dado. (Empty e Error têm aulas próprias;
            // aqui o foco e só a fase de carregamento.)
            return Text(
              snapshot.data ?? '',
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
    );
  }
}
