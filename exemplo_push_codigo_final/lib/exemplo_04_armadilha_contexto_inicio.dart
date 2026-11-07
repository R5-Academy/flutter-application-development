// exemplo_04_armadilha_contexto_inicio.dart
// Ponto de partida: o mesmo padrão do bloco anterior — empurrar, esperar o
// retorno, usar o valor. Só que agora a tela é um `StatelessWidget`, e o valor
// é usado para mostrar uma `SnackBar`.
//
// * Rode e faça o fluxo: escolha "Aceitar" e veja a SnackBar aparecer.
// * **Funciona.**
//
// ! Mas olhe o editor. A linha do `ScaffoldMessenger` está sublinhada, e o
// ! analisador reclama:
// !
// !     Don't use 'BuildContext's across async gaps
// !     (use_build_context_synchronously)
//
// ! Esse aviso é fácil de ignorar — o app roda, o teste passa, o QA aprova. Ele
// ! está falando de um caso que **quase nunca** acontece no seu emulador: entre
// ! o `push` e o retorno, o usuário fecha esta tela (por notificação, deep
// ! link, ou um `pop` de outro lugar). Aí o `context` já não pertence à árvore
// ! (`context.mounted` vira `false`) e o `ScaffoldMessenger.of(context)` estoura
// ! com esta mensagem, medida:
// !
// !     Looking up a deactivated widget's ancestor is unsafe.
//
// ! No bloco anterior a proteção foi `if (!mounted) return;` — mas `mounted` é
// ! do `State`, e aqui **não existe `State`**.
//
// ? O `BuildContext` tem uma propriedade equivalente. Qual?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaConfirmacao()));

class TelaConfirmacao extends StatelessWidget {
  const TelaConfirmacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmação')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _confirmar(context),
          child: const Text('Escolher opção'),
        ),
      ),
    );
  }

  Future<void> _confirmar(BuildContext context) async {
    final resposta = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (novoContext) => const TelaOpcoes()),
    );

    if (!context.mounted) return;

    if (resposta != null) {
      // ! Aqui: context usado depois do await, sem proteção nenhuma. É esta
      // ! linha que o analisador sublinha.
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Você escolheu: $resposta')));
    }
  }
}

class TelaOpcoes extends StatelessWidget {
  const TelaOpcoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opções')),
      body: ListView(
        children: [
          for (final opcao in const ['Aceitar', 'Recusar'])
            ListTile(
              title: Text(opcao),
              onTap: () => Navigator.pop(context, opcao),
            ),
        ],
      ),
    );
  }
}
