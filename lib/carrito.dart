import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'package:flutter_app_tienda_videos/crearCuenta.dart';
import 'inicio.dart';
import 'package:flutter_app_tienda_videos/confirmacionPago.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_tienda_videos/galeria.dart';

class Carrito extends StatelessWidget {
  const Carrito({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Secundario();
  }
}
class Secundario extends StatefulWidget {
  const Secundario({Key? key}) : super(key: key);

  @override
  _SecundarioState createState() => _SecundarioState();
}

class _SecundarioState extends State<Secundario> {
  late List carrito=[];

  getCarrito() async {
    print("PeliculasEstrenos");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/cart", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      setState(() {
        carrito=(json.decode(response.body));
      });
      setState(() {

      });
      print(carrito);
    });
  }
  void deleteQuitarPeliculaCarrito(int id) async{
    print("deleteQuitarPeliculaCarrito");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.delete("http://10.0.2.2:3000/cart/"+id.toString(),headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response){
      //para ejecutar necesita una respuesta(response) se debe enviar desde javascript al menos un res.send("")
      print("despues de eliminar pelicula");
      getCarrito();
      setState(() {

      });
    });

  }
  String obtieneNDias(int diasDespues,String string){
    String fechaSiguienteSemana="";
    var elem=string.split("-");
    var anio=int.parse(elem[0]);
    var mes=int.parse(elem[1]);
    var dia=int.parse(elem[2]);
    var bisiesto=false;
    if(anio%400==0){
      bisiesto=true;
    }
    if(anio%4==0){
      bisiesto=true;
    }
    int dias_mes=0;
    switch(mes) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        dias_mes = 31;
        break;
      case 2:
        if (bisiesto) {
          dias_mes = 29;
        } else {
          dias_mes = 28;
        }
        break;
      default:
        dias_mes = 30;
    }
    if(dia+diasDespues<=dias_mes){
      dia+=diasDespues;
    }else{
      dia=(dia+diasDespues)-dias_mes;
      if(mes==12){
        mes=1;
        anio+=1;
      }else{
        mes+=1;
      }
    }
    fechaSiguienteSemana=anio.toString()+"-"+mes.toString()+"-"+dia.toString();
    print(fechaSiguienteSemana);
    return fechaSiguienteSemana;
  }
  DateTime dateInput=DateTime.now();
  void _datePresent(){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String string = dateFormat.format(DateTime.now());
    showDatePicker(context: context, initialDate: dateFormat.parse(obtieneNDias(1,string)), firstDate: dateFormat.parse(obtieneNDias(1,string)), lastDate: dateFormat.parse(obtieneNDias(7,string)))
        .then((value) =>{
      if(value==null){
      }else{
        setState(() {
          print("Seleccion del dia del usuario");
          dateInput=value;
          //Cuando se tiene un string que se quiere parsear a datime var parsedDate = DateTime.parse(fechaSiguienteSemana);
          DateFormat d = DateFormat("EEEE");
          print( d.format(dateInput));
          switch(d.format(dateInput)){
            case "Sunday":
              String string = dateFormat.format(dateInput);
              dateInput=DateFormat('yyyy-MM-dd').parse(obtieneNDias(1, string));

              break;
            case "Saturday":
              String string = dateFormat.format(dateInput);
              dateInput=DateFormat('yyyy-MM-dd').parse(obtieneNDias(2, string));
              break;
          }
        })
      }
    });
  }
  String usuario="";
  int idUsuario=1;
  getData()async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    setState(() {
      usuario=preferences.getString("usuario")!;
      idUsuario=preferences.getInt("idUsuario")!;
    });
  }
  void initState() {
    // TODO: implement initState
    getData();
    getCarrito();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String string = dateFormat.format(dateInput);
    dateInput=DateFormat('yyyy-MM-dd').parse(obtieneNDias(1, string));
    setState((){
      print("Seleccion del dia del usuario");
      //Cuando se tiene un string que se quiere parsear a datime var parsedDate = DateTime.parse(fechaSiguienteSemana);
      DateFormat d = DateFormat("EEEE");
      print( d.format(dateInput));
      switch(d.format(dateInput)){
        case "Sunday":
          String string = dateFormat.format(dateInput);
          dateInput=DateFormat('yyyy-MM-dd').parse(obtieneNDias(1, string));
          break;
        case "Saturday":
          String string = dateFormat.format(dateInput);
          dateInput=DateFormat('yyyy-MM-dd').parse(obtieneNDias(2, string));
          break;
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito"),
        backgroundColor: Colors.green,
        actions: <Widget>[ppm()],
      ),
      body: SizedBox(
        width: size.width,
        child: ListView(
          children: [
            (usuario!=null)?Text(usuario):Text("No se identifico el usuario"),
            Container(margin:EdgeInsets.symmetric(vertical: 10),child: Center(child: Text("Carrito de peliculas",style: TextStyle(fontSize: 20),))),
            Container(margin:EdgeInsets.symmetric(vertical: 10),child: Center(child: Text("Han agregado la siguientes peliculas",style: TextStyle(fontSize: 18),))),
            Container(//Contenedor que tiene un scrollbar con una lista de widgets que viene de una lista de elementos
              height: 200,
              padding: EdgeInsets.all(5),
              child: Scrollbar(
                child: ((carrito.length<=0)?
                Text("No hay peliculas en el carrito"):
                ListView.builder(//Este listview esta atento a los cambios
                    itemCount: carrito.length, //Sin este valor el listview interpreta una lista infinita, y se queda en un bucle
                    scrollDirection: Axis.vertical,//Sin esto hay error
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int il){//Se ejecuta en cada cambio
                      return Container(
                          color: (il%2==0)?Colors.green:Colors.white,
                          child: Row(
                            children: [
                              Container(
                                child: Image.network(
                                  "https://picsum.photos/"+(carrito[il]["inventory_id"]%1000).toString(),
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*(3/9),
                                child: Column(
                                  children: [
                                    (carrito[il]['title']==null)?Text(""):Text(carrito[il]['title']),//Text(titulos[id2]),
                                    (carrito[il]['description']==null)?Text(""):Text(carrito[il]['description'])//Text(datos[id2])
                                  ],
                                ),
                              ),

                              RaisedButton(
                                  onPressed: (){
                                    deleteQuitarPeliculaCarrito(carrito[il]["inventory_id"]);
                                  },
                                child: Text("Quitar\npelicula"),
                              )
                            ],
                          )
                      );
                    }
                ))),
            ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                children: [
                  Text("Fecha de devolucion"),
                  Container(
                    height: 70,
                    child: Row(
                      children: [
                        Text((dateInput==null)?"no se ha escogido ninguna fecha":DateFormat.yMMMd().format(dateInput)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon:Icon(Icons.calendar_today),onPressed:_datePresent,),
                ],
            ),
              ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Column(
                 children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("TOTAL"),
                      Text(obtenerTotalCarrito())

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("DSCTO"),
                      Text(obtenerDescuento())
                    ],
                  ),
                   SizedBox(height: 10,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Total con DSCTO"),
                      Text(obtenerTotalConDescuento())
                    ],
                  ),
                   SizedBox(height: 10,),
                   RaisedButton(
                    onPressed: () async {
                      print("confirmando pago");
                      int numDias=obtenerNumeroDiasPrestamo();

                      Navigator.push(context,MaterialPageRoute(builder:(context)=>ConfirmacionPago(numDias,dateInput.toString())));
                    },
                    child: Text("Pagar"),
                  )
                ],
              ),
            )

          ]
        )
      )
    );
  }
  Widget ppm(){
    Widget aux;
    return PopupMenuButton(
        icon: Icon(Icons.menu),
        onSelected: (valor){
          setState(() {
            switch(valor){
              case 1:
              //aux = cargaDatos();
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Login()));
                break;
              case 2:
              /*if(dato1.text.toString().isNotEmpty && dato2.text.toString().isNotEmpty) {
                  double d1 = double.parse(dato1.text.toString());
                  double d2 = double.parse(dato2.text.toString());
                  double d3 = d1+d2;
                  aux = operacion('$d1  +   $d2', d3);
                }*/
                Navigator.push(context,MaterialPageRoute(builder:(context)=>CrearCuenta()));
                break;
              case 3:
              /*if(dato1.text.toString().isNotEmpty && dato2.text.toString().isNotEmpty) {
                  double d1 = double.parse(dato1.text.toString());
                  double d2 = double.parse(dato2.text.toString());
                  double d3 = d1+d2;
                  aux = operacion('$d1  +   $d2', d3);
                }*/
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Galeria()));
                break;
            }
          });
        },
        itemBuilder: (context){
          return [
            PopupMenuItem(child: Text('Ingresar'), value: 1,),
            PopupMenuItem(child: Text('Crear cuenta'), value: 2,),
            PopupMenuItem(child: Text('Inicio'), value: 3,),
          ];
        }
    );
  }
  double total=0;
  String obtenerTotalCarrito() {
    total=0;
    total=total+carrito.length*0.99*obtenerNumeroDiasPrestamo();
    return total.toStringAsFixed(2);
  }
  double descuento=0;
  String obtenerDescuento() {
    if(total>=10 && total<15){
      descuento=total*0.1;
      return descuento.toStringAsFixed(2);
    }else{
      if(total>=15 && total<20){
        descuento=total*0.15;
        return descuento.toStringAsFixed(2);
      }else{
        if(total>=20){
          descuento=total*0.2;
          return descuento.toStringAsFixed(2);
        }else{
          descuento=0;
          return descuento.toStringAsFixed(2);
        }
      }
    }
  }
  obtenerNumeroDiasPrestamo() {
    print("obtenerNumeroDiasPrestamo");
    DateFormat dateFormat = DateFormat("yyyy-M-d");
    String stringNow= dateFormat.format(DateTime.now());
    String string = dateFormat.format(dateInput);
    print("fecha seleccionada="+string);
    int i=1;
    for(i=1;i<=7;i++){
      if(string==obtieneNDias(i, stringNow)){
        return i;
      }
    }
    return 1;
  }
  double totalConDescuento=0;
  String obtenerTotalConDescuento() {
    totalConDescuento=total-descuento;
    return totalConDescuento.toStringAsFixed(2);
  }

}

