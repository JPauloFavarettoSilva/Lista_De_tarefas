import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/classes/Tarefa.dart';
import 'package:lista_de_tarefas/widgets/tarefaBoxW.dart';

enum Prioridade { nula, baixa, media, alta, critica, urgente }

extension PrioridadeExtension on Prioridade {
  String get formattedName {
    switch (this) {
      case Prioridade.nula:
        return 'Nenhuma';
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
      case Prioridade.critica:
        return 'Crítica';
      case Prioridade.urgente:
        return 'Urgente';
      default:
        return '';
    }
  }

  static Prioridade? fromFormattedName(String name) {
    switch (name) {
      case 'Nenhuma':
        return Prioridade.nula;
      case 'Baixa':
        return Prioridade.baixa;
      case 'Média':
        return Prioridade.media;
      case 'Alta':
        return Prioridade.alta;
      case 'Crítica':
        return Prioridade.critica;
      case 'Urgente':
        return Prioridade.urgente;
      default:
        return null;
    }
  }
}

class Pesquisar extends StatefulWidget {
  late final List<TarefaBox> listaTarefas;

  Pesquisar({required this.listaTarefas});

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

final TextEditingController horaController = TextEditingController();
final TextEditingController nomeController = TextEditingController();
final TextEditingController descricaoController = TextEditingController();

Prioridade prioridadeSelecionada = Prioridade.baixa;

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
                  SegmentedButton<Prioridade>(
                    segments: Prioridade.values.map((Prioridade prioridade) {
                      return ButtonSegment<Prioridade>(
                        value: prioridade,
                        label: Text(prioridade.formattedName),
                      );
                    }).toList(),
                    selected: <Prioridade>{prioridadeSelecionada},
                    onSelectionChanged: (Set<Prioridade> newSelection) {
                      setState(() {
                        prioridadeSelecionada = newSelection.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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

                      if (prioridadeSelecionada != Prioridade.nula) {
                        atendePrioridade = tarefa.prioridade ==
                            prioridadeSelecionada.formattedName;
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
      ),
    );
  }
}
