import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

// * Bancada compartilhada pelos exemplos desta aula.
// * Ela mostra a CAUSA na tela: o PermissionStatus que voltou do sistema, e a
// * decisao que o app tomou por causa dele. Sem esse painel o aluno so ve o
// * efeito (a camera abriu ou nao) e tem que acreditar no comentario.

/// O que o app registrou na ultima consulta ao sistema.
///
/// Nasce em [PainelDeEstado.aindaNaoConsultado] de proposito: enquanto nenhum
/// codigo tiver perguntado nada ao sistema, o painel diz isso na cara do aluno.
class const LeituraDePermissao({
  final PermissionStatus? status,
  final String decisao = 'nenhuma decisao ainda',
  final String origem = 'nada foi consultado',
}) {
  bool get consultado => status != null;
}

class const PainelDeEstado({
  required final LeituraDePermissao leitura,
  super.key,
}) extends StatelessWidget {
  static const aindaNaoConsultado = LeituraDePermissao();

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cores.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Linha(
            rotulo: 'o que o sistema respondeu',
            valor: leitura.consultado ? leitura.status!.name : '—',
            destaque: true,
          ),
          const SizedBox(height: 8),
          _Linha(rotulo: 'de onde veio', valor: leitura.origem),
          const SizedBox(height: 8),
          _Linha(rotulo: 'o que o app decidiu', valor: leitura.decisao),
        ],
      ),
    );
  }
}

class const _Linha({
  required final String rotulo,
  required final String valor,
  final bool destaque = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 168, child: Text(rotulo, style: texto.labelMedium)),
        Expanded(
          child: Text(
            valor,
            style: destaque
                ? texto.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                : texto.bodyMedium,
          ),
        ),
      ],
    );
  }
}
