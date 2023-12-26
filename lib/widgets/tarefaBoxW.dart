import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/classes/Tarefa.dart';


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

@override
  void initState() {
    super.initState();
    campoDescricao.text = '${widget.valor.descricao}';
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
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 20, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${widget.valor.nome}'),
                  Text('Data: ${_formatarData(widget.valor.hora)}'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 20, 5),
              child: Row(
                children: [
                  Text('Prioridade: ${widget.valor.prioridade}'),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: Text('Concluída:')
                    ),
                  Checkbox(
                    value: concluida,
                    onChanged: (value) {
                      setState(() {
                        concluida = !concluida;
                      });
                    },
                  ),
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
                  decoration: InputDecoration(
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

