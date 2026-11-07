// exemplo_02_todos_os_estados_inicio.dart
// Ponto de partida: a cotação do dólar numa tela, com o `FutureBuilder` olhando
// só o `hasData`. É como quase todo mundo escreve na primeira vez.
//
// ! Rode e cronometre os 2 segundos de espera: a tela fica em BRANCO. Não é
// ! travamento, não é bug de layout — é o `else` devolvendo um `SizedBox` vazio,
// ! porque o dado ainda não chegou e o código não tem nada a dizer sobre isso.
//
// ! Agora troque `buscarCotacao()` por `buscarCotacao(falhar: true)` no
// ! `initState` e rode de novo: o branco fica para SEMPRE. A busca falhou, e a
// ! tela não conta. Nem para o usuário, nem para você — o console fica limpo.
//
// Um `Future` tem três fins possíveis e este código só enxerga um.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCotacao()));

// Simula uma busca que pode falhar.
Future<double> buscarCotacao({bool falhar = false}) async {
  await Future.delayed(const Duration(seconds: 2));
  if (falhar) {
    throw Exception('Servico indisponivel');
  }
  return 5.42;
}

class TelaCotacao extends StatefulWidget {
  const TelaCotacao({super.key});

  @override
  State<TelaCotacao> createState() => _TelaCotacaoState();
}

class _TelaCotacaoState extends State<TelaCotacao> {
  late final Future<double> _futureCotacao;

  @override
  void initState() {
    super.initState();
    _futureCotacao = buscarCotacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotacao do dolar')),
      body: Center(
        child: FutureBuilder<double>(
          future: _futureCotacao,
          builder: (context, snapshot) {
            // ! A única pergunta que este builder faz. Enquanto a resposta for
            // ! "não", ele devolve uma caixa vazia — e a tela não diz nada.
            if (snapshot.hasData) {
              return Text(
                'R\$ ${snapshot.data!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 32),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
