// exemplo_01_has_error_inicio.dart
// Demonstra: o bug que motiva a aula -- um FutureBuilder que só trata "carregando"
// e "dado". Quando o Future FALHA, ninguém lê o hasError e a tela MENTE.
// A ideia central: um throw dentro do Future não quebra o app -- ele vira um
// snapshot com hasError == true. Se você não lê esse hasError, o erro fica
// invisível.
//
// * O QUE ACONTECE DE VERDADE (medido com WidgetTester):
//   - o spinner SOME (CircularProgressIndicator na tela: 0). O Future terminou,
//     então connectionState virou done e o primeiro if para de valer;
//   - sobra uma tela em branco: a Column mede Size(0.0, 0.0), porque
//     snapshot.data e null e o ?? const [] disfarcou a falha;
//   - o erro NÃO aparece no console (takeException() == null). O FutureBuilder
//     guardou a exceção no snapshot -- se você não ler, ninguém lê.
//   O usuário vê o carregamento terminar em NADA e conclui "esse app não tem
//   produtos". Não e verdade: a busca falhou.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProdutos()));

// Serviço fake que SEMPRE falha, simulando a rede fora do ar.
Future<List<String>> buscarProdutos() async {
  await Future.delayed(const Duration(seconds: 1));
  throw Exception('Falha ao conectar ao servidor');
}

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  late final Future<List<String>> _futureProdutos = buscarProdutos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _futureProdutos,
          builder: (context, snapshot) {
            // Só tratamos dois estados: carregando e dado.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              debugPrint(snapshot.stackTrace.toString());
              return const Column(
                mainAxisSize: .min,
                children: [
                  Icon(Icons.cloud_off, size: 48),
                  SizedBox(height: 16),
                  Text('Algo deu errado ao carregar os produtos'),
                ],
              );
            }

            // ! O RAMO DE ERRO NÃO EXISTE. Com o Future falhando, o snapshot vem
            // ! com hasError == true e data == null -- e este código cai aqui. O
            // ! ?? const [] transforma a falha numa lista vazia e a tela fica em
            // ! branco, sem spinner e sem aviso. Rode e veja.
            final produtos = snapshot.data ?? const <String>[];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [for (final p in produtos) Text(p)],
            );
          },
        ),
      ),
    );
  }
}

// ! A OUTRA VERSÃO DESTE MESMO BUG, a que trava de vez: usar só !hasData como
// ! guarda de carregamento.
//
//   if (!snapshot.hasData) return const CircularProgressIndicator();
//
// O erro não produz dado nenhum, então hasData fica false PARA SEMPRE e o spinner
// nunca sai. Medido: 1 CircularProgressIndicator na tela 5 segundos depois de o
// Future já ter falhado. E dai que vem a lenda do "spinner eterno" -- e e por
// isso que a aula de Loading State ensinou a guarda por connectionState
// (waiting && !hasData), e não por hasData sozinho.
