class TarefaBox {
  final String nome;
  final DateTime hora;
  final String? descricao;
  final String prioridade;
  late final bool concluida;

  TarefaBox({
    required this.nome,
    required this.hora,
    required this.prioridade,
    this.descricao,
    required this.concluida,
  });

  factory TarefaBox.fromMap(Map<String, dynamic> map) {
    return TarefaBox(
      nome: map['nome'] as String,
      hora: DateTime.parse(
          map['hora'] as String), // assumindo que a data está em formato String
      descricao: map['descricao'] as String?,
      prioridade: map['prioridade'] as String,
      concluida: map['concluida'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'TarefaBox{nome: $nome, hora: $hora, prioridade: $prioridade, descricao: $descricao, concluida: $concluida}';
  }
}
