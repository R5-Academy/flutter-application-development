// exemplo_04_retorno_de_dados_inicio.dart
// Ponto de partida: a tela de seleção devolve um valor, e a home o recebe com
// `await` — exatamente o padrão da aula de `pop`.
//
// * Roda e funciona: escolha "Azul" e a home mostra "Azul".
//
// ! Mas a rota foi criada **sem o genérico**: `MaterialPageRoute(...)`, não
// ! `MaterialPageRoute<String>(...)`.
//
// ! Passe o mouse sobre a variável `resultado` no editor. O tipo é
// ! **`dynamic`** — o Dart não faz ideia do que vem de volta.
//
// ! O que `dynamic` custa, e nada disso aparece rodando:
// !
// !   `resultado.lenght` (com o erro de digitação) **compila**
// !   o autocomplete não sugere nada em cima do resultado
// !   e o dia em que a tela de seleção passar a devolver um objeto em vez de
// !   uma String, **nada avisa** — o `setState` continua compilando
//
// ? Verificado: em tempo de execução o valor chega igual nos dois casos. O
// ? genérico não muda o comportamento — ele muda **quem confere o seu código**.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _escolhido;

  Future<void> _abrirSelecao() async {
    // ! Rota sem genérico: o resultado chega como dynamic.
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (novoContext) => const SelecaoScreen()),
    );

    if (!mounted) return;

    if (resultado != null) {
      setState(() => _escolhido = resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Escolhido: ${_escolhido ?? 'nada ainda'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _abrirSelecao,
              child: const Text('Escolher cor'),
            ),
          ],
        ),
      ),
    );
  }
}

class SelecaoScreen extends StatelessWidget {
  const SelecaoScreen({super.key});

  static const _cores = ['Azul', 'Verde'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha')),
      body: ListView.builder(
        itemCount: _cores.length,
        itemBuilder: (_, index) {
          final cor = _cores[index];
          return ListTile(
            title: Text(cor),
            onTap: () => Navigator.pop(context, cor),
          );
        },
      ),
    );
  }
}
