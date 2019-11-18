// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/Ayuda.dart';
import 'package:flutter_app/src/provieders/Puch_notificacion_provieder.dart';
import 'package:flutter_app/views/ListadoAyudas.dart';
import 'package:flutter_app/views/NavigatorDrw.dart';

import 'package:flutter_app/views/Appanalitic.dart';

import 'Auth.dart';
import 'LoginUser.dart';

void main() async => (runApp(MyApp()));

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'My app';
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final databaseReference =
      FirebaseDatabase.instance.reference().child("{ayudas}");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: LoginFivePage(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}



class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  void initState(){

    final proviederpush=push_noficacion_Provieder();
    proviederpush.initNotificaciones();

  }
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 75, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Center(
        child: Scaffold(

          extendBody: true,

          backgroundColor: Color.fromARGB(321, 118, 322, 224),

          body: Card(
            margin: EdgeInsets.only(left: 30, right: 30, top: 30),
            elevation: 11,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black26,),
                  suffixIcon: Icon(Icons.check_circle, color: Colors.black26,),
                  hintText: "Buscar",
                  hintStyle: TextStyle(color: Colors.black26),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0)
              ),
            ),
          ),
          // body: ,),
        )),


    Center(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Color.fromARGB(091, 2830, 222, 204),
        body: Padding(
          padding: const EdgeInsets.all(101.0),
          child: Text("holaodood"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: saluda,
          child: Text("add"),
          backgroundColor: Colors.amber,
        ),
        bottomNavigationBar: BackButtonIcon(),
      ),

      //body:images.add("assets/background.jpg"),
    ),
    Center(
      child: Scaffold(
        backgroundColor: Color.fromARGB(200, 300, 222, 204),

        //body:images.add("assets/background.jpg"),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Casa'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text('Trabajo'),
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            title: Text('Gestiones '),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }


  static void saluda() {


  }
}



class listItem {
  listItem(this.value, this.checked);
  final String value;
  bool checked;
  void ische() {
    if (checked = true) print(value.toString());
  }
}




class PlaceList1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Ayudas"),
        backgroundColor: Colors.blue,
        elevation: 2,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.filter_list),
          )
        ],
      ),
      body: Lists(),
    );
  }
}

class Item {
  final String title;
  final String catagory;
  final String place;
  final String ratings;
  final String discount;
  final String image;

  Item(
      {this.title,
      this.catagory,
      this.place,
      this.ratings,
      this.discount,
      this.image});
}

class Lists extends StatelessWidget {
  final List<Item> _data = [
    Item(
        title: 'Tarjeta de bienvenida Galicia ',
        catagory: " Tarxeta benvenida ",
        place: "Galicia",
        ratings: "100%",
        discount: null,
        image:
            "http://www.supercoloring.com/sites/default/files/styles/coloring_medium/public/fif/2016/12/baby-shower-arrival-card-its-a-boy2-paper-craft.png"),
    Item(
        title: 'Singapore Zoo',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: null,
        image:
            "https://images.pexels.com/photos/1736222/pexels-photo-1736222.jpeg?cs=srgb&dl=adult-adventure-backpacker-1736222.jpg&fm=jpg"),
    Item(
        title: 'National Orchid Garden',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: "12 %",
        image:
            "https://images.pexels.com/photos/62403/pexels-photo-62403.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        title: 'Godabari',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: "15 %",
        image:
            "https://images.pexels.com/photos/189296/pexels-photo-189296.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        title: 'Rara National Park',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: "12 %",
        image:
            "https://images.pexels.com/photos/1319515/pexels-photo-1319515.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(6),
      itemCount: _data.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = _data[index];
        return Card(
          elevation: 3,
          child: Row(
            children: <Widget>[
              Container(
                height: 125,
                width: 110,
                padding:
                    EdgeInsets.only(left: 0, top: 10, bottom: 70, right: 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(item.image), fit: BoxFit.cover)),
                child: item.discount == null
                    ? Container()
                    : Container(
                        color: Colors.black38,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              item.discount,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "promo",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                    Text(
                      item.catagory,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      item.place,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          item.ratings,
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Ratings",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
