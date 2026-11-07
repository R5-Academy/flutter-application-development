// exemplo_04_armadilha_inicio.dart
// Ponto de partida: um FutureBuilder cujo Future nasce dentro do `build`.
//
// Rode, espere carregar, e aperte o "+" várias vezes.
//
// ! O texto NÃO muda. Nada pisca. A tela parece perfeita.
// ! E o contador "Buscas disparadas" sobe a cada toque. Cada unidade dessas
// ! seria uma requisição HTTP num app de verdade.
//
// ? Por que a tela não denuncia? Porque ao trocar de future o FutureBuilder
// ? MANTÉM o dado anterior no snapshot — a doc do widget garante isso: "they
// ? will be retained when changing the FutureBuilder configuration to another
// ? future". O estrago é invisível, e é por isso que o contador está na tela.
// ?
// ?   **onde esse Future deveria nascer, para o rebuild não o redisparar?**
// ?
// ? Você já escreveu a resposta no primeiro exemplo desta aula, sem saber que
// ? estava evitando isto.
//
// Segundo experimento, depois de responder: dê um hot restart e aperte "+" a
// cada ~1 segundo DESDE O COMEÇO. O spinner nunca sai — cada rebuild abandona a
// busca em andamento e recomeça os 2 segundos do zero.

import 'package:material_ui/material_ui.dart';

// Contadores só para a demonstração: contam quantas vezes cada busca foi
// disparada. Zeram no hot restart.
int buscasErradas = 0;
int buscasCertas = 0;

Future<String> buscarErrado() async {
  buscasErradas++;
  await Future.delayed(const Duration(seconds: 2));
  return 'Dados carregados';
}

Future<String> buscarCerto() async {
  buscasCertas++;
  await Future.delayed(const Duration(seconds: 2));
  return 'Dados carregados';
}

void main() => runApp(const MaterialApp(home: TelaComparacao()));

class TelaComparacao extends StatefulWidget {
  const TelaComparacao({super.key});

  @override
  State<TelaComparacao> createState() => _TelaComparacaoState();
}

class _TelaComparacaoState extends State<TelaComparacao> {
  int _contador = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onde o Future nasce')),
      floatingActionButton: FloatingActionButton(
        // Cada toque chama setState -> build roda de novo. É aí que a diferença
        // aparece: o rebuild é o que redispara o Future criado no lugar errado.
        onPressed: () => setState(() => _contador++),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rebuilds: $_contador'),
            const SizedBox(height: 32),

            const Text('O Future nasce dentro do build:'),
            FutureBuilder<String>(
              future: buscarErrado(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Text(snapshot.data!);
              },
            ),
            // Este Text é construído DEPOIS do FutureBuilder acima, então já
            // mostra a busca que este mesmo rebuild acabou de disparar.
            Text('Buscas disparadas: $buscasErradas'),
          ],
        ),
      ),
    );
  }
}
