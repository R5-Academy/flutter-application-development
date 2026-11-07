// exemplo_01_minimo_inicio.dart
// Ponto de partida: o Future já disparado, e a tela sem saber disso.
//
// O `buscarNome()` é chamado no `initState` e leva 2 segundos.
//
// Rode e olhe as duas coisas ao mesmo tempo:
//
//   o console  ->  "o Future completou com: Ada Lovelace"  (aos 2s)
//   a tela     ->  spinner, para sempre
//
// ! O dado CHEGA. Ninguém falhou na busca. O que falta é do lado da tela.
//
// ? O problema é de tempo: o `build` é SÍNCRONO. Ele roda uma vez, agora, e
// ? precisa devolver widgets já. O dado só existe dois segundos depois.
// ?
// ?   **quem reconstrói este pedaço da tela quando o Future completa?**
// ?
// ? Repare também no lugar do Future: campo do `State`, criado UMA vez no
// ? `initState`. O motivo de não criá-lo no `build` é o último exemplo desta
// ? aula, e ele custa caro.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaPerfil()));

// Simula uma busca assincrona (imagine uma chamada de rede aqui).
Future<String> buscarNome() async {
  await Future.delayed(const Duration(seconds: 2));

  return 'Ada Lovelace';
}

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: FutureBuilder(
          future: buscarNome(),
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return Text(
              'Olá ${asyncSnapshot.data}!',
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}
