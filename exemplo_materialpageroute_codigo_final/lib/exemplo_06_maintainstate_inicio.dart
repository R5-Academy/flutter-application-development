// exemplo_06_maintainstate_inicio.dart
// Ponto de partida: três telas empilhadas — Home -> Formulário -> Ajuda.
//
// * Rode e faça exatamente isto:
// *   1. abra o Formulário e **digite alguma coisa** no campo;
// *   2. toque em "Abrir ajuda";
// *   3. volte pela seta.
//
// * O que você digitou continua lá. Nada de novo: a aula de `pushReplacement`
// * já mediu que a rota de baixo **continua montada** enquanto outra está por
// * cima — mesmo `State`, mesmo `TextEditingController`, mesmo tudo.
//
// ! Repare no console: o `initState` do Formulário aparece **uma vez só**, e o
// ! `dispose` não aparece enquanto a Ajuda está aberta.
//
// ? Só que "continuar montada" custa memória. Uma tela pesada — uma lista
// ? grande, um mapa, um player — fica inteira na árvore, invisível, enquanto o
// ? usuário olha outra coisa.
// ?
// ? Existe um parâmetro do `MaterialPageRoute` para isso. Ele é um `bool`, o
// ? padrão é `true`, e o nome dele diz o que ele faz: `maintainState`.
// ?
// ? A pergunta que importa não é "como ligo" — é **em qual rota** ele vai, e o
// ? que exatamente se perde quando você desliga.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class const HomeScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              // ! Sem `maintainState`: fica no padrão, `true`.
              MaterialPageRoute<void>(
                maintainState: false,
                builder: (novoContext) => const FormularioScreen(),
              ),
            );
          },
          child: const Text('Abrir formulário'),
        ),
      ),
    );
  }
}

class const FormularioScreen({super.key}) extends StatefulWidget {
  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _controlador = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('initState do Formulário');
  }

  @override
  void dispose() {
    debugPrint('dispose do Formulário');
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 24,
          children: [
            TextField(
              controller: _controlador,
              decoration: const InputDecoration(labelText: 'Digite algo aqui'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (novoContext) => const AjudaScreen(),
                  ),
                );
              },
              child: const Text('Abrir ajuda'),
            ),
          ],
        ),
      ),
    );
  }
}

class AjudaScreen extends StatelessWidget {
  const AjudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: const Center(child: Text('Volte pela seta.')),
    );
  }
}
