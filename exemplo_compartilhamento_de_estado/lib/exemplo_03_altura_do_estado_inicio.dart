// exemplo_03_altura_do_estado_inicio.dart
// Ponto de partida: o estado compartilhado funcionando — e uma coluna que
// depende dele lá no alto.
//
// Cada folha conta os próprios builds. Toque no + e observe: TODAS as folhas
// sobem, mesmo as que não mostram o número.
//
// ? A coluna chama `of(context)` na própria raiz. Funciona, e é a forma mais
// ? natural de escrever — você lê o estado uma vez, no topo, e usa onde
// ? precisar.
// ?
// ?   **quanto custa depender lá em cima?**
// ?
// ? O placar já responde. O que falta é o outro lado da mesma moeda: descer
// ? demais também tem preço, e o preço é a tela quebrar em vez de ficar lenta.

import 'package:material_ui/material_ui.dart';

class ContadorModel extends ChangeNotifier {
  int _valor = 0;
  int get valor => _valor;

  void incrementar() {
    _valor++;
    notifyListeners();
  }
}

class ContadorProvider extends InheritedNotifier<ContadorModel> {
  const ContadorProvider({
    super.key,
    required ContadorModel super.notifier,
    required super.child,
  });

  static ContadorModel of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ContadorProvider>();
    assert(provider != null, 'ContadorProvider não encontrado na árvore');
    return provider!.notifier!;
  }

  static ContadorModel read(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<ContadorProvider>();
    assert(provider != null, 'ContadorProvider não encontrado na árvore');
    return provider!.notifier!;
  }
}

class Raiz extends StatefulWidget {
  const Raiz({super.key});

  @override
  State<Raiz> createState() => _RaizState();
}

class _RaizState extends State<Raiz> {
  final _modelo = ContadorModel();

  @override
  void dispose() {
    _modelo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // * PROVEDOR alto: acima do MaterialApp, então qualquer rota o alcanca.
    return ContadorProvider(
      notifier: _modelo,
      child: const MaterialApp(home: TelaComparacao()),
    );
  }
}

void main() => runApp(const Raiz());

class TelaComparacao extends StatelessWidget {
  const TelaComparacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Altura do estado')),
      body: const Row(children: [Expanded(child: _ColunaDependenciaAlta())]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ContadorProvider.read(context).incrementar(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ! DEPENDÊNCIA ALTA: o of() está na raiz da coluna. Toda a subárvore
// ! não-const abaixo dela reconstrói a cada notifyListeners.
class _ColunaDependenciaAlta extends StatelessWidget {
  const _ColunaDependenciaAlta();

  @override
  Widget build(BuildContext context) {
    final contador = ContadorProvider.of(context);

    return Column(
      children: [
        const _Titulo('of na raiz'),
        _Folha(rotulo: 'folha 1'),
        _Folha(rotulo: 'folha 2'),
        _Folha(rotulo: 'valor: ${contador.valor}'),
      ],
    );
  }
}

class const _Titulo(final String texto) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: Text(texto, style: Theme.of(context).textTheme.titleMedium),
  );
}

// Conta os próprios builds e mostra o número na tela: e o placar da demo.
class const _Folha({required final String rotulo}) extends StatefulWidget {
  @override
  State<_Folha> createState() => _FolhaState();
}

class _FolhaState extends State<_Folha> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;
    return ListTile(
      dense: true,
      title: Text(widget.rotulo),
      trailing: Text('$_builds builds'),
    );
  }
}

// * O outro extremo, para mostrar ao vivo e desfazer (não deixe no arquivo
// * final do aluno rodando): se o provedor descer para dentro do home:, ele
// * fica ABAIXO do Navigator que o MaterialApp cria. A tela inicial continua
// * funcionando — e por isso o bug engana — mas qualquer rota empurrada com
// * Navigator.push nasce fora do alcance e o of() não acha o provedor.
//
//   MaterialApp(
//     home: ContadorProvider(
//       notifier: _modelo,
//       child: const TelaComparacao(),
//     ),
//   )
