// exemplo_02_barrier_inicio.dart
// Ponto de partida: um aviso simples aberto com `showGeneralDialog`, e **sem
// botão de fechar**.
//
// ! Abra e tente sair. Toque fora do card: nada. Toque de novo: nada.
// !
// ! No Android o "voltar" do sistema ainda salva (medido: ele fecha a rota
// ! mesmo com `barrierDismissible: false`). No iOS e no desktop, **não há
// ! saída** — nem o Esc funciona, porque a ação de Esc só está habilitada
// ! quando a rota é dismissible (`widgets/routes.dart:981`).
//
// ? No `showDialog`, tocar fora fechava. Aqui não. Por quê?
//
// ! Porque os padrões são **opostos**:
// !   showDialog        -> barrierDismissible: **true**
// !   showGeneralDialog -> barrierDismissible: **false**
// !
// ! Faz sentido: o `showDialog` sabe que é um diálogo comum, dispensável. O
// ! `showGeneralDialog` não sabe o que você está mostrando, então assume o mais
// ! restritivo — e deixa a decisão com você.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaBarrier()));

class TelaBarrier extends StatelessWidget {
  const TelaBarrier({super.key});

  Future<void> _abrir(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      // ! O padrão aqui é `false` — e não há botão de fechar no card.
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        // ! O Material não é enfeite: sem ele o texto cai no estilo de erro do
        // ! Flutter (48 px, monospace, sublinhado). Explicado no bloco 1.
        return const Material(
          type: MaterialType.transparency,
          child: Center(child: _CardAviso()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('barrier')),
      body: Center(
        child: FilledButton(
          onPressed: () => _abrir(context),
          child: const Text('Abrir diálogo'),
        ),
      ),
    );
  }
}

class _CardAviso extends StatelessWidget {
  const _CardAviso();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tente sair daqui',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Toque fora do card. Não acontece nada.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
