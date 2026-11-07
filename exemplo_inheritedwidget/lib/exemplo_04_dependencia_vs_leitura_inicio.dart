// exemplo_04_dependencia_vs_leitura_inicio.dart
// Ponto de partida: dois leitores do **mesmo** total, lado a lado. O de cima usa
// `CarrinhoScope.of(context)`; o de baixo usa um método `espiar`, que também
// encontra o widget na árvore.
//
// * Os dois compilam, os dois acham o `CarrinhoScope`, os dois leem `total`.
//
// ! Toque no "+" e olhe os dois cartões.
// !
// !   o de cima acompanha: 1, 2, 3...
// !   **o de baixo fica estagnado em 0**
//
// ! Nenhum erro, nenhum aviso. Só um número que não muda — e é assim que esse
// ! bug aparece na vida real: *"meu widget não atualiza"*.
//
// * Olhe a diferença entre os dois métodos. Ela é uma linha:
// *
// *     of()      -> context.dependOnInheritedWidgetOfExactType<CarrinhoScope>()
// *     espiar()  -> context.getInheritedWidgetOfExactType<CarrinhoScope>()
//
// ? Os nomes contam a história. Um deles tem a palavra **`depend`** no começo —
// ? e o bloco 2 já tinha avisado que o `of` faz **duas** coisas, não uma.
// ?
// ? Qual é a segunda?

import 'package:material_ui/material_ui.dart';

class const CarrinhoScope({
  super.key,
  required final int total,
  required final VoidCallback adicionar,
  required super.child,
}) extends InheritedWidget {
  // Acha o ancestral E registra o chamador como dependente.
  static CarrinhoScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CarrinhoScope>();
    assert(scope != null, 'Nenhum CarrinhoScope encontrado no contexto');
    return scope!;
  }

  // ! Acha o ancestral e mais nada.
  static CarrinhoScope? espiar(BuildContext context) {
    return context.getInheritedWidgetOfExactType<CarrinhoScope>();
  }

  @override
  bool updateShouldNotify(CarrinhoScope oldWidget) => total != oldWidget.total;
}

void main() => runApp(const MaterialApp(home: CarrinhoProvider(child: Tela())));

class const CarrinhoProvider({super.key, required final Widget child})
    extends StatefulWidget {
  @override
  State<CarrinhoProvider> createState() => _CarrinhoProviderState();
}

class _CarrinhoProviderState extends State<CarrinhoProvider> {
  int _total = 0;

  void _adicionar() => setState(() => _total++);

  @override
  Widget build(BuildContext context) {
    return CarrinhoScope(
      total: _total,
      adicionar: _adicionar,
      child: widget.child,
    );
  }
}

class Tela extends StatelessWidget {
  const Tela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assinar x espiar')),
      body: const Column(
        children: [
          SizedBox(height: 24),
          _LeitorQueAssina(),
          SizedBox(height: 24),
          _LeitorQueEspia(),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: CarrinhoScope.of(context).adicionar,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class const _Cartao({
  required final String titulo,
  required final int valor,
  required final String nota,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(nota),
        trailing: Text(
          '$valor',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class _LeitorQueAssina extends StatelessWidget {
  const _LeitorQueAssina();

  @override
  Widget build(BuildContext context) {
    final total = CarrinhoScope.of(context).total;
    return _Cartao(
      titulo: 'of(context)',
      valor: total,
      nota: 'assina — acompanha',
    );
  }
}

class _LeitorQueEspia extends StatelessWidget {
  const _LeitorQueEspia();

  @override
  Widget build(BuildContext context) {
    // ! Lê sem assinar: nunca será notificado.
    final total = CarrinhoScope.espiar(context)?.total ?? 0;
    return _Cartao(
      titulo: 'espiar(context)',
      valor: total,
      nota: 'não assina — congela',
    );
  }
}
