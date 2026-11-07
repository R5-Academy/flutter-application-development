// exemplo_01_dialogo_customizado_inicio.dart
// Ponto de partida: a tela de recompensa quer um card **com gradiente roxo**,
// ocupando o cartão inteiro — aquele visual de "você ganhou!".
//
// A tentativa foi pôr o gradiente dentro de um `AlertDialog`.
//
// ! Rode e olhe: o gradiente aparece, mas **dentro de uma moldura branca**. O
// ! `AlertDialog` impõe o próprio fundo, o próprio padding e a própria forma —
// ! e o card fica com uma borda branca em volta que ninguém pediu.
//
// ! Dá para brigar com isso (`backgroundColor: Colors.transparent`,
// ! `contentPadding: EdgeInsets.zero`, `shape` sem borda...). Mas, quando você
// ! precisa desligar tudo o que um widget faz, ele é o widget errado.
//
// * Atenção, porque é aqui que quase todo tutorial erra: a moldura branca é do
// * **`AlertDialog`**, não do `showDialog`. O `builder` do `showDialog` aceita
// * **qualquer** widget — trocar o `AlertDialog` por um `Center(child:
// * Container(...))` já resolveria o visual, sem nenhuma função nova.
//
// ? Então por que existe o `showGeneralDialog`? Guarde a pergunta: a resposta
// ? honesta chega no bloco 3, e não tem a ver com o desenho do card.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaRecompensa()));

class TelaRecompensa extends StatelessWidget {
  const TelaRecompensa({super.key});

  Future<void> _abrirRecompensa(BuildContext context) {
    return showDialog<void>(
      context: context,
      // ! O AlertDialog impõe fundo, padding e forma ao conteúdo.
      builder: (dialogContext) => AlertDialog(
        content: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FF7), Color(0xFFF107A3)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, color: Colors.white, size: 56),
              SizedBox(height: 16),
              Text(
                'Você ganhou!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('showGeneralDialog')),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => _abrirRecompensa(context),
          icon: const Icon(Icons.card_giftcard),
          label: const Text('Resgatar recompensa'),
        ),
      ),
    );
  }
}
