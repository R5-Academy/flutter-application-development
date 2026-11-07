// exemplo_02_tela_de_vazio_inicio.dart
// Ponto de partida: a lista de tarefas, com o carregamento já tratado. A busca
// resolve com SUCESSO — só que sem nenhum item.
//
// ! Rode: o spinner aparece por 1 segundo e some, e o que fica é uma área
// ! CINZA VAZIA. Nada explica o que houve. O usuário não sabe se o app quebrou,
// ! se a internet caiu ou se ele simplesmente não tem tarefas.
//
// ! Repare que não há bug nenhum aqui: o `Future` completou, o `hasData` é
// ! `true`, o `ListView.builder` foi construído. Ele só recebeu `itemCount: 0` e
// ! desenhou exatamente isso — nada.
//
// "Ter dados" e "ter itens" são coisas diferentes, e este código trata as duas
// como se fossem a mesma.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaTarefas()));

class const Tarefa(final String titulo);

// A busca resolve com SUCESSO, porém sem nenhum item.
// Troque o retorno por uma lista com Tarefas para ver a lista aparecer.
Future<List<Tarefa>> buscarTarefas() async {
  await Future.delayed(const Duration(seconds: 1));
  return const <Tarefa>[]; // resolveu, porém vazia
}

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  late final _tarefas = buscarTarefas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      body: FutureBuilder<List<Tarefa>>(
        future: _tarefas,
        builder: (context, snapshot) {
          // Carregando: enquanto o Future esta pendente.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tarefas = snapshot.data ?? const <Tarefa>[];

          // ! Do carregamento a gente pula direto para a lista. Com zero itens,
          // ! o ListView constrói zero linhas — e entrega a área em branco.
          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, i) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(tarefas[i].titulo),
            ),
          );
        },
      ),
    );
  }
}
