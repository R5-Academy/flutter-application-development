// exemplo_01_01_problema_estado_isolado_inicio.dart
// Ponto de partida: a PRIMEIRA saída errada, já rodando.
//
// A tela de produtos guarda a quantidade em estado LOCAL, com setState. O botão
// funciona e o número sobe — mas o carrinho, que é outra rota, nasce zerado.
// São rotas irmãs: não existe caminho de pai/filho entre as duas.
//
// ? Se o estado local não atravessa a rota, o reflexo é subir o valor para um
// ? lugar que todo mundo enxerga: uma variável no topo do arquivo (ou um campo
// ? static). Ela é global, então a outra rota com certeza vai encontrá-la.
// ?
// ?   **e a tela em que você já está — ela fica sabendo?**
// ?
// ? É o que vamos escrever agora. A resposta é o motivo de esta aula existir.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProdutos()));

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  // Estado LOCAL desta tela. Vive só aqui.
  int _quantidade = 0;

  @override
  Widget build(BuildContext context) {
    // Botões empilhados no próprio body: cada leitura fica colada no botão que
    // deveria muda-la, e o layout não depende da largura da janela.
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Local (setState): $_quantidade'),
            FilledButton(
              onPressed: () => setState(() => _quantidade++),
              child: const Text('Adicionar'),
            ),
            const SizedBox(height: 32),
            TextButton(
              // ! Levamos o usuário para o carrinho, mas o _quantidade fica
              // ! para tras: a outra rota nasce zerada.
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaCarrinho()),
                );
              },
              child: const Text('Ver carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaCarrinho extends StatelessWidget {
  const TelaCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ! O estado local da tela anterior não chega aqui de jeito nenhum:
            // ! são rotas irmas, sem relação de pai/filho. Sempre 0.
            Text('Do setState da tela anterior: 0'),
          ],
        ),
      ),
    );
  }
}
