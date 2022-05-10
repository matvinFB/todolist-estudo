
class Tarefa{
  String _nome = "";
  bool _concluida = false;

  Tarefa(this._nome);

  Tarefa._loading(this._nome, this._concluida);

  factory Tarefa.fromJson(Map<String, dynamic> data){
    final nome = data["nome"] as String;
    final concluida = data["concluida"] as bool;
    return Tarefa._loading(nome, concluida);
  }


  @override
  toJson() {

    return {"nome":_nome, "concluida": _concluida};
  }

  set concluida(bool value) {
    _concluida = value;
  }

  bool get concluida => _concluida;

  String get nome => _nome;
}