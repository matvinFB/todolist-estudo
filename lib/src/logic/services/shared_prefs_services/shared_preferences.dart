import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../model/tarefa.dart';
class SharedPrefs{


  salvar(dados)async{
    print("salvando...");
    dados = json.encode(dados);
    print(dados);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString ("tarefas", dados.runtimeType == String? dados : "");
    print("salvo");
    return;
  }

  recuperar()async{
    final prefs = await SharedPreferences.getInstance();
    var dados = await (prefs.getString("tarefas") ?? "[]");
    print(dados);
    return List.from(json.decode(dados).map((t)=>Tarefa.fromJson(t)));
  }

  remover()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("tarefas");
    return;
  }
}