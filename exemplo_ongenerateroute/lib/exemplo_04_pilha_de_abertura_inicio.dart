// exemplo_04_pilha_de_abertura_inicio.dart
// O mesmo roteador dinâmico do bloco 2, agora respondendo a um **deep link**:
// o `initialRoute` chega como `/produto/42`, como se o app tivesse sido aberto
// pelo link de um e-mail. A função `gerarRota` é bancada — é a lógica que você
// já escreveu, só que num lugar onde dá para chamá-la de dois pontos.
//
// ! Rode e olhe o topo da tela: o produto 42 abriu, e há uma **seta de voltar**.
// ! Toque nela.
//
// ! Aparece "Rota não encontrada: /produto". O app abriu com **três** rotas
// ! empilhadas (medido com um `NavigatorObserver`): a raiz, um degrau para
// ! `/produto` — que não é tela nenhuma — e o destino. O degrau do meio nem
// ! nome tem, porque quem o construiu foi o `default` da `gerarRota`.
//
// ! Isso não é bug do seu roteador: é o comportamento padrão de abertura, que
// ! quebra o caminho em degraus (a aula 07 mostrou isso com
// ! `/perfil/config`). Ele assume que cada pedaço do caminho é uma tela
// ! registrada — o que deixa de valer no instante em que o último pedaço é um
// ! **id**.
//
// ? Quem decide a pilha de abertura é um parâmetro só. Se ele é meu, a pilha
// ? passa a ser a que eu quiser.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppAbertoPorLink());

class AppAbertoPorLink extends StatelessWidget {
  const AppAbertoPorLink({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilha de abertura',
      // Simula o deep link: o app é aberto direto na rota do produto.
      initialRoute: '/produto/42',
      onGenerateRoute: gerarRota,
    );
  }
}

// A mesma lógica do bloco 2, agora numa função top-level: assim ela pode ser
// chamada tanto pela navegação normal quanto por quem monta a abertura.
Route<dynamic>? gerarRota(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '/');
  final segmentos = uri.pathSegments;

  if (segmentos.isEmpty) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => const CatalogoScreen(),
    );
  }

  if (segmentos.length == 2 && segmentos.first == 'produto') {
    final id = int.tryParse(segmentos[1]);
    if (id != null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => ProdutoScreen(id: id),
      );
    }
  }

  return MaterialPageRoute<void>(
    builder: (context) => TelaRotaDesconhecida(nome: settings.name),
  );
}

class const Produto(final int id, final String nome);

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  static const _produtos = [
    Produto(42, 'Teclado mecânico'),
    Produto(7, 'Mouse sem fio'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (_, index) {
          final produto = _produtos[index];
          return ListTile(
            title: Text(produto.nome),
            subtitle: Text('/produto/${produto.id}'),
            onTap: () => Navigator.pushNamed(context, '/produto/${produto.id}'),
          );
        },
      ),
    );
  }
}

class const ProdutoScreen({super.key, required final int id})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produto #$id')),
      body: Center(child: Text('Detalhe do produto $id')),
    );
  }
}

class const TelaRotaDesconhecida({super.key, required final String? nome})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ops')),
      body: Center(child: Text('Rota não encontrada: $nome')),
    );
  }
}
