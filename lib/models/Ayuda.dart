import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';


class Ayuda {
  String descripcion;
  String titulo;
  Ayuda(this.descripcion,this.titulo);


  Ayuda.fromJson(var value){
  this.descripcion = value['descripcion'];
  this.titulo = value['titulo'];
  }
  }




class MyFirstApp extends StatefulWidget {
  @override
  _MyFirstAppState createState() => new _MyFirstAppState();
}
class _MyFirstAppState extends State<MyFirstApp> {
  final dataBaseReference = FirebaseDatabase.instance.reference().child("galiappfirebd");
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Datos FireBase lista datos y guardar datos "),
      ),
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new RaisedButton(
              child: new Text("Guardar Archivos"),
              onPressed: (){
                GuardarArchivo();
              },
            ),
            new RaisedButton(
              child: new Text("Ver Archivos"),
              onPressed: (){
                getData();
              },
            ),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                        ''' Nuevo Contenedor '''
                    ),

                  )
                ],

              ),color: Colors.amberAccent
            )
          ],
        ),
      ),backgroundColor: Colors.blueGrey
    );
  }
  void GuardarArchivo(){
    dataBaseReference.child("ayudas").set({
      'title':"ayudas b ",
      'description':"Desacripcion completa de la ayuda"
    });
  }
  void getData(){

    dataBaseReference.once().then((DataSnapshot snapshot){
      //print('Data: $snapshot.value');
      //new Text('$snapshot');
      for(var value in snapshot.value.values){
        print(value);


      }

    });
  }
}