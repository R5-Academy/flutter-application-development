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

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  // * O Future é guardado num campo e criado UMA vez, no initState.
  // Se ele nascesse dentro do build, cada rebuild criaria um novo e reiniciaria
  // a busca (essa é a armadilha do exemplo 04).
  late final Future<String> _futureNome;

  @override
  void initState() {
    super.initState();
    _futureNome = buscarNome();
    // Instrumentação do exemplo: prova, no console, que o dado CHEGA.
    _futureNome.then((nome) => debugPrint('o Future completou com: $nome'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(child: const CircularProgressIndicator()),
    );
  }
}
