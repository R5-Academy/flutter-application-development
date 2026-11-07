// exemplo_01_o_problema_inicio.dart
// Ponto de partida: a busca já existe e o loading já está tratado. Falta só
// pintar o resultado na tela.
//
// ? O caminho feliz parece uma linha: se tem dado, mostra a lista. Vamos
// ? escrever exatamente isso — do jeito que todo mundo escreve, sem nenhum
// ? truque.
// ?
// ?   **e reparar no que a tela mostra quando a busca resolve.**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProblema()));

class const Tarefa(final String titulo);

// Simula uma busca no servidor que resolve com SUCESSO, mas sem nenhum item.
// Troque o retorno para uma lista com Tarefas e veja a lista aparecer.
Future<List<Tarefa>> buscarTarefas() async {
  await Future.delayed(const Duration(seconds: 1));
  return const <Tarefa>[]; // resolveu, porém vazia
}

class TelaProblema extends StatefulWidget {
  const TelaProblema({super.key});

  @override
  State<TelaProblema> createState() => _TelaProblemaState();
}

class _TelaProblemaState extends State<TelaProblema> {
  // O Future fica num campo, criado UMA vez -- não dentro do build.
  // (A armadilha "não crie o Future no build" e da aula de FutureBuilder.)
  late final _tarefas = buscarTarefas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      body: FutureBuilder<List<Tarefa>>(
        future: _tarefas,
        builder: (context, snapshot) {
          // Loading tratado corretamente: enquanto espera, mostra o spinner.
          if (snapshot.connectionState == .waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final tarefas = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  ...tarefas.map(
                    (t) => ListTile(
                      leading: Icon(Icons.check_circle_outline),
                      title: Text(t.titulo),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
