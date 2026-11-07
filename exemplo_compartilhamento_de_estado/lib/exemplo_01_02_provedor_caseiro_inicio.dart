// exemplo_01_02_provedor_caseiro_inicio.dart
// Ponto de partida: as duas peças da seção, prontas e sem conversar uma com a
// outra.
//
//   CarrinhoModel     o ChangeNotifier — sabe guardar e sabe avisar
//   CarrinhoProvider  o InheritedNotifier — sabe alcançar a árvore inteira
//
// A tela mostra "No carrinho: 0" e o botão não faz nada: ninguém montou o
// provedor, e ninguém sabe encontrá-lo.
//
// ? Você já viu as duas separadas. O modelo resolve **quem é avisado**; o
// ? escopo resolve **como o dado chega**. Falta juntá-las — e são poucas linhas.
// ?
// ?   **onde, na árvore, o provedor precisa entrar para valer até em outra
// ?   rota?**
// ?
// ? A resposta dá o título do bloco seguinte, e é a razão de o `runApp` abaixo
// ? estar tão vazio.

import 'package:material_ui/material_ui.dart';

// * O MODELO de estado. Guarda os dados e avisa quem escuta via notifyListeners.
class CarrinhoModel extends ChangeNotifier {
  int _quantidade = 0;

  int get quantidade => _quantidade;

  void adicionar() {
    _quantidade++;
    notifyListeners(); // sem isto, a UI dependente não rebuilda
  }
}

// * A PONTE. InheritedNotifier já escuta o Listenable (o ChangeNotifier):
// * quando o modelo chama notifyListeners(), os dependentes rebuildam sozinhos.
// O elemento dele da addListener no construtor (inherited_notifier.dart:95) e
// removeListener no unmount (:132); o callback só marca sujo e pede build
// (:119-122). Por isso não precisamos sobrescrever updateShouldNotify: a versão
// base já compara os notifiers (`oldWidget.notifier != notifier`, :85-87) e
// cobre o caso de trocar o objeto. Um InheritedWidget cru e que EXIGE escrever
// esse metodo na mao.
class CarrinhoProvider extends InheritedNotifier<CarrinhoModel> {
  const CarrinhoProvider({
    super.key,
    required CarrinhoModel super.notifier,
    required super.child,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TelaProdutos());
  }
}

class TelaProdutos extends StatelessWidget {
  const TelaProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: const Center(child: Text('No carrinho: 0')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
