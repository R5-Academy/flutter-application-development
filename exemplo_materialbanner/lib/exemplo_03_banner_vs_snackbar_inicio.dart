// exemplo_03_banner_vs_snackbar_inicio.dart
// Ponto de partida: dois avisos da mesma tela, e **os dois** como SnackBar.
//
// O primeiro está certo: "Alterações salvas" é um recado, some e pronto.
//
// ! O segundo, não. "Atualização disponível" pede uma **decisão** — e nem
// ! oferece um botão para tomá-la. Nenhum dos dois tem `action`, então os dois
// ! somem sozinhos em ~4 s (medido). Se a pessoa não estava olhando, ela nunca
// ! soube que havia uma atualização.
//
// ! Repare que os dois avisos aparecem no **mesmo lugar**, com a **mesma
// ! duração** e a **mesma aparência** — apesar de serem coisas muito
// ! diferentes: um informa, o outro pede.
//
// ? Cada tipo de aviso tem o seu widget. Qual é a pergunta que separa os dois?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: BannerVsSnackbarPage()));

class BannerVsSnackbarPage extends StatelessWidget {
  const BannerVsSnackbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banner × SnackBar')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.south),
              // Recado sem decisão: SnackBar é o certo.
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alterações salvas')),
                );
              },
              label: const Text('Aviso: alterações salvas'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.south),
              // ! Pede decisão — e, sem `action`, some em ~4 s levando-a junto.
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Atualização disponível.')),
                );
              },
              label: const Text('Aviso: atualização disponível'),
            ),
          ],
        ),
      ),
    );
  }
}
