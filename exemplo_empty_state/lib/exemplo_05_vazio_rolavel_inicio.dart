// exemplo_05_vazio_rolavel_inicio.dart
// Ponto de partida: o estoque vazio, com a mensagem certinha e um
// `RefreshIndicator` em volta para o usuário puxar e recarregar.
//
// Rode e tente puxar a tela para baixo.
//
// ! Não acontece nada. O gesto de "puxar para atualizar" sumiu — e o usuário
// ! fica preso num vazio que ele não consegue recarregar.
//
// ? Olhe o que aconteceu com a árvore quando a lista esvaziou: a `ListView` foi
// ? trocada por um `Center`. Com ela, foi embora o único widget ROLÁVEL da tela.
// ?
// ?   **e sem nada rolável, de onde viria o overscroll que dispara o refresh?**
// ?
// ? Esta é a armadilha número 1 do empty state, e ela aparece exatamente no
// ? momento em que o usuário mais precisa recarregar.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaEstoque()));

class TelaEstoque extends StatefulWidget {
  const TelaEstoque({super.key});

  @override
  State<TelaEstoque> createState() => _TelaEstoqueState();
}

class _TelaEstoqueState extends State<TelaEstoque> {
  var _recargas = 0;

  Future<void> _recarregar() async {
    await Future.delayed(const Duration(seconds: 1));
    // O mounted depois do await e cuidado de ciclo de vida (aula Async e
    // Lifecycle, no fim desta seção).
    if (!mounted) return;
    setState(() => _recargas++);
  }

  @override
  Widget build(BuildContext context) {
    final vazio = _VazioDeEstoque(recargas: _recargas);

    return Scaffold(
      appBar: AppBar(title: const Text('Estoque')),
      body: RefreshIndicator(
        onRefresh: _recarregar,
        child: Center(child: vazio),
      ),
    );
  }
}

class const _VazioDeEstoque({required final int recargas})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 96,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhum produto em estoque',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Puxe a tela para baixo para buscar de novo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            'Recargas: $recargas',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
