// exemplo_01_materialbanner_minimo_inicio.dart
// Ponto de partida: avisar que existe uma nova versão do app — com o `SnackBar`
// da aula passada, e com a ação "ATUALIZAR" dentro dele.
//
// * Ele NÃO some. Você viu o motivo na aula passada: `persist` vale
// * `action != null` por default, então SnackBar com ação espera pela pessoa.
// * Aperte o botão e conte até dez — a barra continua lá.
//
// ! Só que "não sumir" resolve metade do problema. Repare no rodapé: a barra
// ! ficou **por cima** do total e do botão FINALIZAR. O app não abriu espaço
// ! para o aviso; ele foi colocado em cima do que já estava na tela.
//
// ! E tem mais duas limitações do formato: cabe **uma** ação só (`action` é um
// ! `SnackBarAction?`, no singular), e um arrasto para baixo tira a barra da
// ! tela — a pessoa dispensa o aviso sem ter decidido nada.
//
// ? Existe um aviso que fica na tela **abrindo espaço para si**, aceita mais de
// ? uma ação, e não sai enquanto o seu código não mandar.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: BannerMinimoPage()));

class BannerMinimoPage extends StatelessWidget {
  const BannerMinimoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MaterialBanner mínimo')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // ! Fica na tela (persist), mas fica em cima do rodapé.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Uma nova versão do app está disponível.',
                      ),
                      action: SnackBarAction(
                        label: 'ATUALIZAR',
                        onPressed: () {},
                      ),
                    ),
                  );
                },
                child: const Text('Mostrar aviso'),
              ),
            ),
          ),
          // Rodapé fixo: é ele que some debaixo do SnackBar.
          const _RodapeDoPedido(),
        ],
      ),
    );
  }
}

class _RodapeDoPedido extends StatelessWidget {
  const _RodapeDoPedido();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Expanded(child: Text('Total: R\$ 189,90')),
            FilledButton(onPressed: () {}, child: const Text('FINALIZAR')),
          ],
        ),
      ),
    );
  }
}
