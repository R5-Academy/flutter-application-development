// exemplo_03_transition_inicio.dart
// Ponto de partida: o card do bloco anterior, com o barrier já configurado e
// **sem** `transitionBuilder`.
//
// * Abra e feche algumas vezes olhando para o card. Ele **já entra num fade** —
// * isso não é mágica nem sorte: quando você não passa `transitionBuilder`, a
// * rota devolve um `FadeTransition` por conta própria
// * (`widgets/routes.dart:2673-2674`). Medido, com o padrão de 200 ms:
// *
// *   t=0ms opacity=0.00 | t=50ms 0.25 | t=100ms 0.50 | t=150ms 0.75 | t=200ms 1.00
//
// ! Ou seja: o `transitionBuilder` **não serve para "adicionar animação onde
// ! não havia"**. Ele serve para **substituir** a que já existe. Quem diz que
// ! "sem transitionBuilder o diálogo pipoca" nunca mediu.
//
// ? Então qual é o problema deste arquivo? O fade é sempre o mesmo, para
// ? qualquer diálogo. E o card de recompensa do bloco 1 — aquele "você
// ? ganhou!" — pedia entrar **crescendo**, não desbotando.
//
// ? E é aqui que a aula responde à pergunta que ficou no bloco 1: o
// ? `showDialog` **não** deixa trocar o tipo de transição. Ele aceita um
// ? `AnimationStyle` para mudar duração e curva (medido: `AnimationStyle(
// ? duration: 600ms)` vira `transitionDuration = 600ms`), mas a transição
// ? continua sendo um fade. Trocar o **tipo** só o `showGeneralDialog` permite.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaTransicao()));

class TelaTransicao extends StatelessWidget {
  const TelaTransicao({super.key});

  Future<void> _abrir(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      // ! Sem transitionBuilder a rota usa o fade padrão, de 200 ms.
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return const _CardSimples();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('transitionBuilder')),
      body: Center(
        child: FilledButton(
          onPressed: () => _abrir(context),
          child: const Text('Abrir'),
        ),
      ),
    );
  }
}

class _CardSimples extends StatelessWidget {
  const _CardSimples();

  @override
  Widget build(BuildContext context) {
    // ! O Material nao e enfeite: sem ele o texto cai no estilo de erro do
    // ! Flutter (48 px, monospace, sublinhado). Explicado no bloco 1.
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 48, color: Colors.deepPurple),
              SizedBox(height: 16),
              Text(
                'Entrei no fade padrão',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'O mesmo fade de sempre. E se eu quisesse crescer?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
