class TarefaBox {
  final String nome;
  final DateTime hora;
  final String? descricao;
  final int prioridade;
  late final bool concluida;

  TarefaBox({
    required this.nome,
    required this.hora,
    required this.prioridade,
    this.descricao,
    required this.concluida,
  });

  @override
  String toString() {
    return 'TarefaBox{nome: $nome, hora: $hora, prioridade: $prioridade, descricao: $descricao, concluida: $concluida}';
  }
}
