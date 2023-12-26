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
        title: Text('Pesquisar Tarefa'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          TextField(
            controller: horaController,
            decoration: InputDecoration(
              labelText: 'Data',
              hintText: 'dd/MM/aaaa hh:mm',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Propriedade:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
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
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 33, 191, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  try {
                    data = DateFormat('dd/MM/yyyy HH:mm').parseStrict(horaController.text);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Data Inválida'),
                          content: Text(
                              'A data inserida não é válida. Por favor, insira uma data no formato correto (dd/MM/yyyy HH:mm).'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  listaPesquisada = listaTarefas
                      .where((tarefa) =>
                          tarefa.prioridade >= prioridadeSelecionada &&
                          tarefa.hora == data!)
                      .toList(); 

                  listaPesquisada.sort((a, b) => a.hora.compareTo(b.hora));

                  print(listaPesquisada.toString());

                  setState(() {});
                },
                child: Text(
                  'Pesquisar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
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
