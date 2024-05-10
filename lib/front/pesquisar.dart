import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/classes/Tarefa.dart';
import 'package:lista_de_tarefas/widgets/tarefaBoxW.dart';

class Pesquisar extends StatefulWidget {
  late final List<TarefaBox> listaTarefas;

  Pesquisar({required this.listaTarefas});

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

final TextEditingController horaController = TextEditingController();
final TextEditingController nomeController = TextEditingController();
final TextEditingController descricaoController = TextEditingController();

int prioridadeSelecionada = 1;

List<TarefaBox> listaPesquisada = [];
late List<TarefaBox> listaTarefas;

class _PesquisarState extends State<Pesquisar> {
  late DateTime? data;
  late List<TarefaBox> listaPesquisada;

  @override
  void initState() {
    super.initState();
    listaPesquisada = [];
    listaTarefas = widget.listaTarefas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Tarefa'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
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
          TextField(
            controller: horaController,
            decoration: const InputDecoration(
              labelText: 'Data',
              hintText: 'dd/MM/aaaa hh:mm',
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
                    'Prioriedade:',
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
                    items: List.generate(6, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text((index).toString()),
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
                  if (horaController.text.isNotEmpty) {
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
                  }

                  listaPesquisada = listaTarefas.where((tarefa) {
                    bool atendePrioridade = true;
                    bool atendeHora = true;
                    bool atendeNome = true;
                    bool atendeDescricao = true;

                    if (prioridadeSelecionada != 0) {
                      atendePrioridade =
                          tarefa.prioridade == prioridadeSelecionada;
                    }

                    if (horaController.text.isNotEmpty) {
                      atendeHora = tarefa.hora == data!;
                    }

                    if (nomeController.text.isNotEmpty) {
                      atendeNome = tarefa.nome == nomeController.text;
                    }

                    if (descricaoController.text.isNotEmpty) {
                      atendeDescricao =
                          tarefa.descricao == descricaoController.text;
                    }

                    return atendePrioridade &&
                        atendeHora &&
                        atendeNome &&
                        atendeDescricao;
                  }).toList();

                  listaPesquisada.sort((a, b) => a.hora.compareTo(b.hora));

                  setState(() {});
                },
                child: const Text(
                  'Pesquisar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: listaPesquisada.length,
              itemBuilder: (context, index) {
                return TarefaBoxWidget(
                  valor: listaPesquisada[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
