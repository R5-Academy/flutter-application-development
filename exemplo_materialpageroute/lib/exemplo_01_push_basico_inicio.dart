// exemplo_01_push_basico_inicio.dart
// Ponto de partida: a navegação que você já escreve há três aulas — o
// `MaterialPageRoute` construído **dentro** da chamada do `push`.
//
// * Funciona, e é assim que se escreve na maioria das vezes.
//
// ? Mas repare na forma da linha. O `push` recebe **dois** argumentos: o
// ? contexto e... o quê, exatamente? Aquele `MaterialPageRoute(...)` no meio da
// ? chamada é fácil de ler como "sintaxe do push" — parte da cerimônia.
//
// ? Não é. É um **objeto**, de uma classe com construtor e parâmetros, como
// ? qualquer outro. E até agora ele só existiu espremido dentro de um `push`,
// ? o que esconde três coisas: que ele pode ser guardado numa variável, que
// ? tem outros parâmetros além do `builder`, e que **não é a única classe de
// ? rota que existe**.
//
// ? Esta aula é sobre esse objeto. Vamos começar tirando ele de dentro do push.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // A rota nasce e é empilhada na mesma expressão.
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (novoContext) => const DetalheScreen(),
              ),
            );
          },
          child: const Text('Abrir detalhe'),
        ),
      ),
    );
  }
}

class DetalheScreen extends StatelessWidget {
  const DetalheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe')),
      body: const Center(child: Text('Cheguei aqui pelo push.')),
    );
  }
}
