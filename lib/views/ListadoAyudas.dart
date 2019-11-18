import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListadoAyudas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        body: Container(
          child: getContent(context),
        ));
  }
}

@override
Widget getContent(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("ayudas").snapshots(),
      builder: (context, snap) {
        //compruebo los datos si son nullos
        if (snap.data == null) return CircularProgressIndicator();
        navigateDatail(DocumentSnapshot post) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(
                        post: post,
                      )));
        }

        return new ListView.builder(
          padding: EdgeInsets.all(15.0),
          reverse: false,
          itemCount: snap.data.documents.length,
          itemBuilder: (_, int index) {
            return Container(
              width: 230.0,
              height: 146.10,
              child: ListTile(
                  title: Text(
                    snap.data.documents[index].data['titulo'],
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w900,
                        fontSize: 19),
                  ),
                  subtitle: Text(
                    snap.data.documents[index].data['enlace'],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snap.data.documents[index].data['image']),
                  ),
                  onTap: () => navigateDatail(snap.data.documents[index])),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.blue,
                    blurRadius: 13.0,
                  ),
                ],

                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                gradient: new LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.blueGrey],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    tileMode: TileMode.repeated),
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            );
          },
        );
      });
}

//bundel de detalles de cada ayuda
class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  _detailpageSate createState() => _detailpageSate();
}

class _detailpageSate extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            widget.post.data["titulo"],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: AlignmentDirectional(20, 20),
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.lightBlueAccent,
                    blurRadius: 80.0,
                  ),
                ],
              ),
              child: Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                color: Colors.white,
                child: Column(children: <Widget>[
                  Text(
                    widget.post.data["titulo"],
                    style: new TextStyle(
                      letterSpacing: 02.3,
                      color: Colors.purpleAccent,

                      //backgroundColor: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Image.network(
                    widget.post.data["image"],
                    width: 300.0,
                    height: 220.0,
                  ),
                  ListTile(
                    title: Text(
                      widget.post.data["enlace"],
                      style: new TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text(widget.post.data["descripcion"],
                        style: new TextStyle(color: Colors.blueGrey)),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    title: Text(
                      widget.post.data["requisitos"],
                      style: new TextStyle(
                          color: Colors.green, fontWeight: FontWeight.normal),
                    ),
                    subtitle: (Text("Nota")),
                  ),
                  Divider(
                    color: Colors.blue.shade100,
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.center),
              ),
            ),
          ),
        ));
  }
}
