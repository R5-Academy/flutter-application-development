// exemplo_05_popuntil_inicio.dart
// O mesmo checkout do bloco 3, agora com o passo seguinte: da tela de Sucesso,
// o usuário quer voltar para a Home.
//
// A Home mostra um placar: quantas vezes ela foi CRIADA (o `initState`) e o que
// ela tinha carregado. Rode e repare que ele diz "1" na abertura.
//
// ! Percorra o fluxo até o Sucesso e toque em "Voltar ao início". A Home
// ! aparece — e o placar vai para 2. A tela que o usuário conhecia foi jogada
// ! fora e construída de novo: o scroll voltou ao topo e o que estava carregado
// ! foi buscado outra vez.
//
// ? A gente empurrou uma Home nova por cima da pilha limpa. Mas a Home antiga
// ? estava ali embaixo o tempo todo, viva. Será que dá para simplesmente
// ? DESCER até ela, em vez de criar outra?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // Placar da aula: quantas vezes esta tela foi construída do zero.
  static int vezesCriada = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    HomePage.vezesCriada++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            Text('Home criada ${HomePage.vezesCriada}x'),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (novoContext) => const CarrinhoPage(),
                  settings: const RouteSettings(name: '/carrinho'),
                ),
              ),
              child: const Text('Ir ao carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (novoContext) => const PagamentoPage(),
              settings: const RouteSettings(name: '/pagamento'),
            ),
          ),
          child: const Text('Ir ao pagamento'),
        ),
      ),
    );
  }
}

class PagamentoPage extends StatelessWidget {
  const PagamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (novoContext) => const SucessoPage(),
            ),
            ModalRoute.withName('/'),
          ),
          child: const Text('Confirmar pagamento'),
        ),
      ),
    );
  }
}

class SucessoPage extends StatelessWidget {
  const SucessoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sucesso')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            const Text('Pedido confirmado'),
            FilledButton(
              // ! Empilha uma Home NOVA depois de apagar tudo. Funciona — mas
              // ! a Home que o usuário já tinha aberta é descartada no caminho.
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (novoContext) => const HomePage(),
                ),
                (rota) => false,
              ),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}
