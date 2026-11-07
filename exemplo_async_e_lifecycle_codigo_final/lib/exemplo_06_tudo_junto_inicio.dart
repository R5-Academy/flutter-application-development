// exemplo_06_tudo_junto_inicio.dart
// Ponto de partida: uma tela com cara de app — carga inicial, um relógio vindo
// de um Stream, e uma ação que confirma com um diálogo depois de um await.
//
// Ela funciona. Rode e use normalmente que nada quebra.
//
// ! Agora use MAL: saia da tela no meio do carregamento, saia enquanto o
// ! relógio corre, dispare a ação e volte antes de ela terminar. Cada um desses
// ! caminhos quebra de um jeito diferente — e todos os quatro problemas você já
// ! resolveu, um por vez, nos exemplos anteriores desta aula.
//
// ? Este é o exercício de fechamento: os mesmos quatro cuidados, agora numa
// ? tela só, onde eles não vêm rotulados.
// ?
// ?   **quantos pontos deste arquivo precisam de proteção, e quais?**
//
// (São quatro. Um deles não é o `mounted` do State — é o do `context`.)

import 'dart:async';

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaTarefas()));

// "API" simulada: devolve a lista inicial de tarefas após 2 segundos.
Future<List<String>> buscarTarefas() async {
  await Future.delayed(const Duration(seconds: 2));
  return ['Estudar async', 'Revisar ciclo de vida', 'Fazer os exercicios'];
}

// "Salvar" simulado: demora 1 segundo e conclui.
Future<void> salvarTarefas() async {
  await Future.delayed(const Duration(seconds: 1));
}

// Relogio ao vivo: emite a hora atual a cada segundo.
Stream<DateTime> relogio() {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
}

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  List<String>? _tarefas;
  // ! Assinado no initState e nunca cancelado — o analyzer já reclama de
  // ! ele estar sem uso, e o uso que falta é justamente o cancel().
  // ignore: unused_field
  StreamSubscription<DateTime>? _relogioSub;
  DateTime? _agora;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    // * Pilar 1: a carga começa no initState
    _carregar();
    // * Pilar 3: assinatura começa no initState
    _relogioSub = relogio().listen((momento) {
      // * Pilar 2: Verifique se o BuildContext ainda está ativo(tela ativa! )

      if (!mounted) return;
      setState(() => _agora = momento);
    });
  }

  @override
  void dispose() {
    //
    // ! O QUE NÃO CABE AQUI: ler InheritedWidget. Um Theme.of(context) ou
    // * Pilar 3 (parte 2): Assinou no initState, cancela no dispose.
    _relogioSub?.cancel();
    super.dispose();
  }

  Future<void> _carregar() async {
    final tarefas = await buscarTarefas();
    // * Pilar 2: mounted depois do await, antes do setState.

    if (!mounted) return;
    setState(() => _tarefas = tarefas);
  }

  Future<void> _salvar() async {
    setState(() => _salvando = true);

    await salvarTarefas();

    // * Pilar 4: depois do await, o context pode estar morto. Aqui usamos o
    // * context DO PRÓPRIO State (this.context), então o guarda certo e o
    // * mounted do State. Sem esta linha, o ScaffoldMessenger abaixo faz o
    // * analyzer acusar use_build_context_synchronously (medido).
    //
    // ! A ARMADILHA: trocar por `if (!context.mounted) return;` AQUI DENTRO
    // ! NÃO resolve -- continua acusando, com outra mensagem (medida):
    // !   "Don't use 'BuildContext's across async gaps, guarded by an
    // !    unrelated 'mounted' check. Guard a 'State.context' use with a
    // !    'mounted' check on the State, and other BuildContext use with a
    // !    'mounted' check on the BuildContext"
    // ! A regra: context do State -> `mounted`. Context recebido por parâmetro
    // ! (ex.: `Future<void> aoTocar(BuildContext context) async`) -> `context.mounted`.
    //
    // ! E não adianta ler o mounted ANTES do await: o analyzer também acusa, e
    // ! com razão — o valor lido antes do gap já é velho quando o gap termina.
    if (!mounted) return;
    setState(() => _salvando = false);
    // ! O analyzer ACUSA esta linha: "Don't use BuildContexts across async
    // ! gaps" (use_build_context_synchronously). O aviso é o assunto do quarto
    // ! pilar — está silenciado aqui só para o `_inicio` compilar limpo.
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Tarefas salvas')));
  }

  @override
  Widget build(BuildContext context) {
    final tarefas = _tarefas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas tarefas'),
        actions: [
          if (_salvando)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(onPressed: _salvar, icon: const Icon(Icons.save)),
        ],
      ),
      body: tarefas == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (_, index) {
                final tarefa = tarefas[index];
                return ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(tarefa),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: Text(
            _agora == null
                ? 'Sincronizando...'
                : 'Atualizado as ${_agora!.hour.toString().padLeft(2, '0')}:'
                      '${_agora!.minute.toString().padLeft(2, '0')}:'
                      '${_agora!.second.toString().padLeft(2, '0')}',
          ),
        ),
      ),
    );
  }
}
