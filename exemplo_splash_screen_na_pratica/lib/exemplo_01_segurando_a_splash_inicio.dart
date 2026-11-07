import 'package:material_ui/material_ui.dart';

import 'cardapio.dart';

void main() {
  runApp(const AppDaCafeteria());
}

class AppDaCafeteria extends StatelessWidget {
  const AppDaCafeteria({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Cafeteria do Bairro',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: const Color(0xFF6F4E37)),
    home: const TelaDoCardapio(),
  );
}

class TelaDoCardapio extends StatefulWidget {
  const TelaDoCardapio({super.key});

  @override
  State<TelaDoCardapio> createState() => _TelaDoCardapioState();
}

class _TelaDoCardapioState extends State<TelaDoCardapio> {
  List<ItemDoCardapio>? _itens;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final itens = await Cardapio.carregar();
    if (!mounted) return;
    setState(() => _itens = itens);
  }

  @override
  Widget build(BuildContext context) {
    final itens = _itens;
    return Scaffold(
      appBar: AppBar(title: const Text('Cafeteria do Bairro')),
      body: itens == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: itens.length,
              itemBuilder: (_, index) {
                final item = itens[index];
                return ListTile(
                  title: Text(item.nome),
                  trailing: Text('R\$ ${item.preco.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
