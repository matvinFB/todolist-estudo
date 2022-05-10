import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../logic/model/tarefa.dart';
import '../../logic/services/shared_prefs_services/shared_preferences.dart';
import '../utils/constants.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  var tarefas = [];
  var prefs = SharedPrefs();
  bool isChecked = false;
  TextEditingController controller = TextEditingController();




  void initState() {
    _carrega_tarrefas();
    print("initState() called");
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _add(){
    if(controller.text == ""){
      return;
    }
    setState(() {
      tarefas.add(Tarefa(controller.text));
      controller.text = "";
      FocusManager.instance.primaryFocus?.unfocus();
      prefs.salvar(tarefas);
    });

  }
  void _remove(index){
    showDialog(
        context: context,
        builder: (BuildContext){
          return AlertDialog(
            title: Text("Remover tarefa"),
            content: Text("Tarefa: \"${tarefas[index].nome}\" será removida."),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    setState(() {

                    });
                    Navigator.pop(context);
                    },
                  child: Text("CANCELAR")
              ),
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      tarefas.removeAt(index);
                      prefs.salvar(tarefas);
                    });
                    Navigator.pop(context);
                  },
                  child: Text("PROSSEGUIR")
              )
            ],
          );
        });


  }
  _carrega_tarrefas() async {
    print("_carrega_tarrefas");
    var temp = await prefs.recuperar();
    setState(() {
      tarefas = temp;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: MAIN_COLOR,
        actions: [
          IconButton(
              onPressed: (){
                print("Upload");
                setState(() {
                  _carrega_tarrefas();
                });
              }
              , icon: Icon(Icons.refresh)
          ),
          IconButton(
              onPressed: (){
                print("Upload");
                setState(() {
                  tarefas = [];
                });
              }
              , icon: Icon(Icons.delete)
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //ListView code inside Expanded
            Expanded(
                child: ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child:Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_){
                      _remove(index);
                    },
                    child: CheckboxListTile(
                        title: Text(tarefas[index].nome),
                        value: tarefas[index].concluida,
                        onChanged: (bool? value) {
                          setState(() {
                            tarefas[index].concluida = value!;
                            prefs.salvar(tarefas);
                          });
                        }),
                  ) ,
                  onLongPress: () {
                      _remove(index);
                  },
                );
              },
            )),
            //TextField code inside Wrap
            Wrap(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextField(
                    maxLength:140,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: Text('Tarefa'),
                    ),
                    onSubmitted:(texto){
                      _add();
                    },
                    controller: controller,
                  )
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MAIN_COLOR,
        child: Icon(Icons.add),
        onPressed: () {
          _add();
        },
      ),
    );
  }
}
