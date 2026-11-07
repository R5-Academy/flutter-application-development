// exemplo_03_recarregar_dados_inicio.dart
// Demonstra: pull-to-refresh com cara de app de verdade, recarregando dados
// de uma "API" simulada.
// Novo em relação ao 02: o onRefresh busca dados novos (Future que devolve uma
// lista) e a UI reflete o resultado. Diferenca entre "carregar a primeira vez"
// e "recarregar" (o RefreshIndicator e o recarregar).

import 'dart:math';

//
// Ponto de partida: a tela carrega da "API" na primeira vez e tem o gesto de
// puxar — mas o `onRefresh` está vazio.
//
// Rode: a lista aparece. Puxe: o spinner some na hora e nada muda.
//
// ? Carregar a primeira vez e recarregar são dois momentos diferentes, e é fácil
// ? confundi-los: o primeiro é o `initState`, o segundo é este gesto.
// ?
// ?   **o que precisa acontecer aqui dentro para a lista trocar de verdade?**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProdutos()));

// Modelo simples de dado.
class const Produto(final String nome, final double preco);

// "API" simulada: um Future que demora e devolve uma nova página de produtos.
// No mundo real isto seria uma chamada de rede atras de um Repository - a
// camada de dados e assunto de Flutter Advanced (Arquitetura Recomendada).
class FakeApi {
  static final _rnd = Random();
  static const _nomes = ['Teclado', 'Mouse', 'Monitor', 'Webcam', 'Headset'];

  static Future<List<Produto>> buscarProdutos() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(6, (i) {
      final nome = _nomes[_rnd.nextInt(_nomes.length)];
      final preco = 50 + _rnd.nextInt(450) + _rnd.nextDouble();
      return Produto('$nome #${_rnd.nextInt(999)}', preco);
    });
  }
}

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  List<Produto> _produtos = [];
  bool _carregandoInicial = true;

  @override
  void initState() {
    super.initState();
    // Carga inicial (sem gesto): mostramos um loading enquanto o primeiro
    // conjunto de dados não chega. Reaproveita a ideia de Loading State.
    _cargaInicial();
  }

  Future<void> _cargaInicial() async {
    final dados = await FakeApi.buscarProdutos();
    setState(() {
      _produtos = dados;
      _carregandoInicial = false;
    });
  }

  // * onRefresh: busca dados novos e troca a lista. O spinner do
  // RefreshIndicator segue este Future do inicio ao fim.
  Future<void> _recarregar() async {
    final novos = await FakeApi.buscarProdutos();
    setState(() => _produtos = novos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          // A busca funciona: este botão prova. Falta ligá-la ao gesto.
          IconButton(
            onPressed: _recarregar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar pelo botão',
          ),
        ],
      ),
      body: _carregandoInicial
          // Loading da PRIMEIRA carga: o RefreshIndicator não cobre este caso,
          // ele só trata a recarga por gesto.
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              // O gesto chama isto — e isto não faz nada.
              onRefresh: () async {},
              child: ListView.separated(
                // Sem controller e no eixo vertical, esta lista já recebe
                // AlwaysScrollableScrollPhysics do próprio ScrollView - o
                // gesto funciona mesmo se o refresh devolver 1 produto só.
                itemCount: _produtos.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final p = _produtos[index];
                  return ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text(p.nome),
                    trailing: Text('R\$ ${p.preco.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
    );
  }
}
