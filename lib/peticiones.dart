import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Peticiones {
    late List tareas;
    get(String direccion) async {
    print("Obtener tareas");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get(direccion, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      print(response);
      tareas=[];
      tareas = json.decode(response.body);
      print("Despeues del getTareas------------------------------------------------------------------------------------------");
      print(tareas);

    });
  }
}
