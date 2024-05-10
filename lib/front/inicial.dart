import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/classes/Tarefa.dart';
import 'package:lista_de_tarefas/front/cadastro.dart';
import 'package:lista_de_tarefas/front/concluidas.dart';
import 'package:lista_de_tarefas/front/pesquisar.dart';
import 'package:lista_de_tarefas/widgets/tarefaBoxW.dart';

class TelaInicial extends StatefulWidget {
  final List<TarefaBox> listaTarefas;

  TelaInicial({required this.listaTarefas});

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late List<TarefaBox> listaTarefas;
  late List<TarefaBox> listaConcluida = [];

  @override
  void initState() {
    super.initState();
    listaTarefas = widget.listaTarefas;
    _verificarConcluidas();
  }

  void _verificarConcluidas() {
    listaTarefas.removeWhere((tarefa) {
      if (tarefa.concluida) {
        listaConcluida.add(tarefa);
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Criar Nova Tarefa'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CadastroTarefa(listaTarefas: listaTarefas)),
                );
              },
            ),
            ListTile(
              title: const Text('Completas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Concluidas(listaTarefas: listaTarefas)),
                );
              },
            ),
            ListTile(
              title: const Text('Pesquisar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Pesquisar(listaTarefas: listaTarefas)),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: listaTarefas.length,
          itemBuilder: (context, index) {
            return TarefaBoxWidget(valor: listaTarefas[index]);
          },
        ),
      ),
    );
  }
}
