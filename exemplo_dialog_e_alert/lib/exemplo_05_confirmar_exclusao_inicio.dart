// exemplo_05_confirmar_exclusao_inicio.dart
// Ponto de partida: a lista de tarefas, com uma lixeira em cada item.
//
// ! Toque na lixeira. A tarefa some. Sem pergunta, sem aviso, sem desfazer.
//
// ! E a lixeira fica a poucos pixels do texto do item — num celular, no ônibus,
// ! um toque de raspão apaga o trabalho de alguém.
//
// A regra: **ação destrutiva e irreversível pede confirmação**. E confirmação é
// tudo o que esta aula construiu — retorno, barreira, ícone e o par de botões.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaTarefas()));

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final List<String> _tarefas = [
    'Estudar AlertDialog',
    'Revisar formulários',
    'Fazer os exercícios',
  ];

  void _excluir(int indice) {
    // ! Apaga direto, sem perguntar nada.
    setState(() => _tarefas.removeAt(indice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      body: Column(
        children: [
          for (var i = 0; i < _tarefas.length; i++)
            ListTile(
              title: Text(_tarefas[i]),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _excluir(i),
              ),
            ),
        ],
      ),
    );
  }
}
