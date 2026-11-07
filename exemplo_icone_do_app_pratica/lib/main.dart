// Bancada, nao exemplo: por isso NAO tem par _inicio/_completo.
//
// O app existe so para ser instalado e ter um icone na gaveta. Nenhuma linha
// daqui muda durante a aula — o que muda e o `pubspec.yaml` e a arvore de
// arquivos nativos que o `flutter_launcher_icons` escreve.
import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDaCafeteria());

class AppDaCafeteria extends StatelessWidget {
  const AppDaCafeteria({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Cafeteria do Bairro',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: const Color(0xFF6F4E37)),
    home: const TelaDosArquivosFonte(),
  );
}

/// Mostra os tres arquivos que alimentam o `flutter_launcher_icons`, para o
/// professor compara-los com o resultado depois de rodar o comando.
class TelaDosArquivosFonte extends StatelessWidget {
  const TelaDosArquivosFonte({super.key});

  static const _fontes = [
    _Fonte(
      arquivo: 'icone_fonte.png',
      papel: 'Vai virar o icone achatado e o do iOS',
      caminho: 'assets/icone/icone_fonte.png',
      fundo: Color(0xFF6F4E37),
    ),
    _Fonte(
      arquivo: 'icone_foreground.png',
      papel: 'Camada da frente do adaptativo',
      caminho: 'assets/icone/icone_foreground.png',
      fundo: Color(0xFFE8DED3),
    ),
    _Fonte(
      arquivo: 'icone_monochrome.png',
      papel: 'Camada do icone tematico',
      caminho: 'assets/icone/icone_monochrome.png',
      fundo: Color(0xFFE8DED3),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cafeteria do Bairro')),
    body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _fontes.length,
      itemBuilder: (_, index) => _fontes[index],
    ),
  );
}

class _Fonte extends StatelessWidget {
  const _Fonte({
    required this.arquivo,
    required this.papel,
    required this.caminho,
    required this.fundo,
  });

  final String arquivo;
  final String papel;
  final String caminho;
  final Color fundo;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      leading: ColoredBox(
        color: fundo,
        child: Image.asset(caminho, width: 56, height: 56),
      ),
      title: Text(arquivo),
      subtitle: Text(papel),
    ),
  );
}
