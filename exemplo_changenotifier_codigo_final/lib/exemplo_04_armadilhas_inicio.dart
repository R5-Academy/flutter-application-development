// exemplo_04_armadilhas_inicio.dart
// Ponto de partida: uma lista de tarefas com DOIS métodos escritos do jeito
// que se escreve sem pensar — e um placar na tela para medir o estrago.
//
// O placar conta duas coisas diferentes, e a aula inteira mora na distância
// entre elas:
//   notifyListeners()  — quantas vezes o modelo avisou;
//   builds do builder  — quantas vezes o builder de fato rodou.
//
// Rode e experimente, zerando o placar (botão da AppBar) antes de cada um:
//
//   "1 (sem notificar)"     -> a tarefa entra na lista e a tela não muda.
//   "5 (notifica no loop)"  -> anote os DOIS números antes de virar a página.
//
// ? O primeiro botão é o bug número 1 de quem começa: "adicionei e nada
// ? aparece". O segundo é mais sutil — ele funciona, a tela fica certa. Antes
// ? de escrever a correção, arrisque um palpite:
// ?
// ?   **cinco notifyListeners() no mesmo frame dão quantos builds?**
// ?
// ? Os dois botões verdes estão apagados de propósito: eles chamam os métodos
// ? que ainda não existem.

import 'package:material_ui/material_ui.dart';

class ListaDeTarefas extends ChangeNotifier {
  final List<String> _tarefas = [];

  List<String> get tarefas => List.unmodifiable(_tarefas);

  // ! ERRADO: muta a lista mas ESQUECE notifyListeners(). O campo muda, a tela
  // não. Sintoma: "adicionei mas nada aparece".
  void adicionarErrado(String tarefa) {
    _tarefas.add(tarefa);
    notifyListeners();
    // faltou notifyListeners();
  }

  // ! ERRADO: notifica DENTRO do loop, item a item, para uma única operação
  // lógica.
  void adicionarVariosErrado(List<String> novas) {
    for (final t in novas) {
      _tarefas.add(t);
      notifyListeners();
    }
  }

  void adicionarVariosCorreto(List<String> novas) {
    _tarefas.addAll(novas);
    notifyListeners();
  }
}

void main() => runApp(const MaterialApp(home: TelaTarefas()));

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  late final ListaDeTarefas _lista;
  int _contador = 0;

  // Instrumentação do exemplo (não faz parte do padrão ChangeNotifier):
  // _avisos conta quantas vezes o notifier avisou; _builds conta quantas vezes
  // o builder do ListenableBuilder rodou de verdade.
  int _avisos = 0;
  int _builds = 0;

  @override
  void initState() {
    super.initState();
    _lista = ListaDeTarefas();
    // Registramos ANTES do ListenableBuilder, então este ouvinte roda primeiro
    // e o builder já lê o número atualizado. Sem setState de propósito: quem
    // dispara o rebuild é o próprio ListenableBuilder.
    _lista.addListener(_contarAviso);
  }

  void _contarAviso() => _avisos++;

  @override
  void dispose() {
    _lista.removeListener(_contarAviso);
    _lista.dispose();
    super.dispose();
  }

  void _zerarMedicao() => setState(() {
    _avisos = 0;
    // ! Começamos em -1 de propósito: este próprio setState reconstrói a tela
    // e, junto com ela, o builder do ListenableBuilder — o que já somaria 1.
    // Assim o placar aparece zerado logo após o frame do "zerar".
    _builds = -1;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Armadilhas do ChangeNotifier'),
        actions: [
          IconButton(
            onPressed: _zerarMedicao,
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Zerar a medição',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _lista,
        builder: (context, child) {
          _builds++;
          return Column(
            children: [
              _Placar(avisos: _avisos, builds: _builds),
              const Divider(height: 1),
              Expanded(
                child: _lista.tarefas.isEmpty
                    ? const Center(child: Text('Nenhuma tarefa'))
                    : ListView.builder(
                        itemCount: _lista.tarefas.length,
                        itemBuilder: (_, index) {
                          final t = _lista.tarefas[index];
                          return ListTile(dense: true, title: Text(t));
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () =>
                    _lista.adicionarErrado('Tarefa ${++_contador}'),
                child: const Text('1 (sem notificar)'),
              ),
              const FilledButton(
                onPressed: null,
                child: Text('1 (notificando)'),
              ),
              FilledButton.tonal(
                onPressed: () => _lista.adicionarVariosErrado([
                  for (var i = 0; i < 5; i++) 'Tarefa ${++_contador}',
                ]),
                child: const Text('5 (notifica no loop)'),
              ),
              FilledButton(
                onPressed: () => _lista.adicionarVariosCorreto([
                  for (var i = 0; i < 5; i++) 'Tarefa ${++_contador}',
                ]),
                child: Text('5 (notifica 1x)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _Placar({required final int avisos, required final int builds})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Numero(rotulo: 'notifyListeners()', valor: avisos),
          _Numero(rotulo: 'builds do builder', valor: builds),
        ],
      ),
    );
  }
}

class const _Numero({required final String rotulo, required final int valor})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('$valor', style: tema.headlineMedium),
        Text(rotulo, style: tema.labelMedium),
      ],
    );
  }
}
