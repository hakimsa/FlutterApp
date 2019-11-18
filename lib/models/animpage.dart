//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Ayuda.dart';

class animpage extends StatefulWidget {
 // final databaseReference = FirebaseDatabase.instance.reference().child("ayudas");static final String path = "lib/src/pages/animations/anim3.dart";
  @override
  _animpageState createState() => _animpageState();
}




class _animpageState extends State<animpage> {
  ScrollController _scrollController = ScrollController();
  Color appBarBackground;
  double topPosition;
  @override
  void initState() {
    topPosition = -80;
    appBarBackground = Colors.transparent;
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  double _getOpacity() {
    double op = (topPosition + 80) / 80;
    return op > 1 || op < 0 ? 1 : op;
  }

  _onScroll() {
    if (_scrollController.offset > 50) {
      if (topPosition < 0)
        setState(() {
          topPosition = -130 + _scrollController.offset;
          if (_scrollController.offset > 130) topPosition = 0;
        });
    } else {
      if (topPosition > -80)
        setState(() {
          topPosition--;
          if (_scrollController.offset <= 0) topPosition = -80;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 50),
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 170),
                      Text(
                        "Awesome App Welcom Bebe",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      ),

                      const SizedBox(height: 20.0),
                      Text(
                        "Benviendos",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                Container(
                  height: 300,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 300,
                  color: Colors.amber,
                ),
                const SizedBox(height: 30.0),
                Container(
                  height: 300,
                  color: Colors.lightGreen,
                  width:150,

                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 300,
                  color: Colors.pink,
                  child: new Container(
                    width: 300,
                    color: Colors.white,
                    child: Text("HELLO"),
                  ),
                ),
                const SizedBox(height: 100.0),
              ],
            ),
          ),
          Positioned(
              top: topPosition,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                padding: const EdgeInsets.only(left: 50,top: 25.0,right: 20.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0)),
                  color: Colors.white.withOpacity(_getOpacity()),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  child: Semantics(
                    child: Text(
                      'Welcom to  my app',
                      style: TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.bold),
                    ),
                    header: true,
                  ),
                ),
              )
          ),
          SizedBox(
            height: 180,
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
    );

  }
}
