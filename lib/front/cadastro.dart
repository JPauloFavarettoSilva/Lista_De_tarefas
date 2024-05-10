import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/classes/Tarefa.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/front/inicial.dart';

class CadastroTarefa extends StatefulWidget {
  late final List<TarefaBox> listaTarefas;

  CadastroTarefa({required this.listaTarefas});

  @override
  _CadastroTarefaState createState() => _CadastroTarefaState();
}

class _CadastroTarefaState extends State<CadastroTarefa> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  int prioridadeSelecionada = 1;

  List<TarefaBox> listaTarefas = [];

  @override
  void initState() {
    super.initState();
    listaTarefas = widget.listaTarefas;
  }

  @override
  Widget build(BuildContext context) {
    horaController.text = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: horaController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prioridade:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButton<int>(
                      value: prioridadeSelecionada,
                      onChanged: (int? novoVal) {
                        setState(() {
                          prioridadeSelecionada = novoVal!;
                        });
                      },
                      items: List.generate(5, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text((index + 1).toString()),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 191, 243),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {
                    DateTime? data;

                    try {
                      data = DateFormat('dd/MM/yyyy HH:mm')
                          .parseStrict(horaController.text);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Data Inválida'),
                            content: const Text(
                                'A data inserida não é válida. Por favor, insira uma data no formato correto (dd/MM/yyyy HH:mm).'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    if (nomeController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Nome Inválido'),
                            content: const Text('Por favor insira um nome.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    TarefaBox novaTarefa = TarefaBox(
                      nome: nomeController.text,
                      hora: data!,
                      prioridade: prioridadeSelecionada,
                      descricao: descricaoController.text,
                      concluida: false,
                    );

                    listaTarefas.add(novaTarefa);

                    listaTarefas.sort((a, b) => a.hora.compareTo(b.hora));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TelaInicial(listaTarefas: listaTarefas),
                      ),
                    );

                    nomeController.clear();
                    horaController.clear();
                    descricaoController.clear();
                    prioridadeSelecionada = 1;

                    return;
                  },
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
