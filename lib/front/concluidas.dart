import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/widgets/tarefaBoxW.dart';
import 'package:lista_de_tarefas/classes/Tarefa.dart';

class Concluidas extends StatefulWidget {
  final List<TarefaBox> listaTarefas;
  Concluidas({required this.listaTarefas});

  @override
  _ConcluidasState createState() => _ConcluidasState();
}

class _ConcluidasState extends State<Concluidas> {
  late List<TarefaBox> listaTarefas;

  @override
  void initState() {
    super.initState();
    listaTarefas = widget.listaTarefas;
  }

  @override
  Widget build(BuildContext context) {
    List<TarefaBox> listaConcluida =
        listaTarefas.where((tarefa) => tarefa.concluida == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Concluídas'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: listaConcluida.length,
          itemBuilder: (context, index) {
            return TarefaBoxWidget(
              valor: listaConcluida[index],
            );
          },
        ),
      ),
    );
  }
}
