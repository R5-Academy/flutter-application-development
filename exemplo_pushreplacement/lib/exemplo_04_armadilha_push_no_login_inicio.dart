// exemplo_04_armadilha_push_no_login_inicio.dart
// Ponto de partida: um checkout em três passos — endereço, pagamento, revisão.
// Depois de aprender que `pushReplacement` evita o "voltar" indesejado, o dev
// aplicou ele **em todas** as transições do fluxo.
//
// * A intenção até faz sentido: cada passo terminou, então por que deixá-lo na
// * pilha?
//
// ! Rode e vá até a revisão. Agora **tente voltar para corrigir o endereço**.
// !
// !   não há seta em passo nenhum
// !   o voltar do sistema fecha o app
// !   e o usuário que digitou o CEP errado precisa **começar tudo de novo**
//
// ! É o erro simétrico ao do bloco 3. Lá, `push` mantinha na pilha uma tela que
// ! devia sair. Aqui, `pushReplacement` descarta telas que **deviam ficar**.
//
// ! E este é mais difícil de perceber: o app "funciona", ninguém vê exceção, e
// ! o problema só aparece quando alguém erra alguma coisa — que é justamente
// ! quando o usuário mais precisa de ajuda.
//
// ? Então a regra não é "`pushReplacement` é melhor". A pergunta do bloco 1
// ? continua valendo, e é ela que decide **caso a caso**.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: PassoEndereco()));

class PassoEndereco extends StatelessWidget {
  const PassoEndereco({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1. Endereço')),
      body: Center(
        child: FilledButton(
          // ! pushReplacement no meio do fluxo: o endereço some da pilha.
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (novoContext) => const PassoPagamento(),
            ),
          ),
          child: const Text('Continuar para pagamento'),
        ),
      ),
    );
  }
}

class PassoPagamento extends StatelessWidget {
  const PassoPagamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2. Pagamento')),
      body: Center(
        child: FilledButton(
          // ! E de novo.
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (novoContext) => const PassoRevisao(),
            ),
          ),
          child: const Text('Continuar para revisão'),
        ),
      ),
    );
  }
}

class PassoRevisao extends StatelessWidget {
  const PassoRevisao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3. Revisão')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                Navigator.canPop(context)
                    ? 'canPop: true — dá para voltar e corrigir.'
                    : 'canPop: false — os passos anteriores sumiram da pilha.',
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton(
              // ! Botão apagado: ele só liga quando o pedido puder ser criado —
              // ! e é aí que a decisão push x pushReplacement volta a aparecer.
              onPressed: null,
              child: const Text('Confirmar pedido'),
            ),
          ],
        ),
      ),
    );
  }
}

// O fim da linha do fluxo: depois daqui, o pedido existe.
class TelaConfirmacao extends StatelessWidget {
  const TelaConfirmacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido confirmado')),
      body: Center(
        child: Text(
          Navigator.canPop(context)
              ? 'canPop: true — a seta ainda leva a um passo do checkout.'
              : 'canPop: false — não há como voltar e confirmar de novo.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
