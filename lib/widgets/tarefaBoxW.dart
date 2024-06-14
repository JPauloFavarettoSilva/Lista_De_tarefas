import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/classes/Tarefa.dart';
import 'package:lista_de_tarefas/front/inicial.dart';
import 'package:lista_de_tarefas/front/pesquisar.dart';

String _formatarData(DateTime data) {
  return DateFormat('dd/MM/yyyy HH:mm').format(data);
}

class TarefaBoxWidget extends StatefulWidget {
  final TarefaBox valor;

  TarefaBoxWidget({required this.valor});

  @override
  _TarefaBoxWidgetState createState() => _TarefaBoxWidgetState();
}

class _TarefaBoxWidgetState extends State<TarefaBoxWidget> {
  bool clicado = false;
  TextEditingController campoDescricao = TextEditingController();
  bool concluida = false;
  Color _currentColor = Colors.white;
  String _currentText = 'Concluir';

  @override
  void initState() {
    super.initState();
    campoDescricao.text = '${widget.valor.descricao}';
  }

  void _changeColor() {
    setState(() {
      // Alternar entre azul e vermelho
      _currentColor =
          (_currentColor == Colors.white) ? Colors.green : Colors.white;
    });
  }

  void _changeText() {
    setState(() {
      _currentText = (_currentText == 'Concluir') ? 'Voltar' : 'Concluir';
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          clicado = !clicado;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _currentColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${widget.valor.nome}'),
                  Text('Data: ${_formatarData(widget.valor.hora)}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
              child: Row(
                children: [
                  Text('Prioridade: ${widget.valor.prioridade}'),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(200, 5, 5, 5),
                    child: ElevatedButton(
                        onPressed: () {
                          concluida = !concluida;
                          _changeColor();
                          _changeText();
                        },
                        child: Text(_currentText)),
                  )
                ],
              ),
            ),
            if (clicado)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: campoDescricao,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Sua tarefa',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
