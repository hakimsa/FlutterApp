import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import 'ListadoAyudas.dart';
import 'MyLogin.dart';
import 'NavigatorDrw.dart';
import 'main.dart';

Future siignInWithGoogle() async {
  final googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential));

// Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  String name = user.displayName;
  print(name);
  String email = user.email;
  String imageUrl = user.photoUrl;

// Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return NavigatorDrw1();
}

class NavigatorDrw1 extends StatefulWidget{
  FirebaseUser user;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DrawererState();
  }
}
  class DrawererState extends State<NavigatorDrw1>{
  FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return UserAccountsDrawerHeader(
      accountName:Text(user.email),
      accountEmail:Text(user.displayName),
      currentAccountPicture:CircleAvatar( backgroundImage: AssetImage("assets/images/galibebe.jpg"),
      ),otherAccountsPictures: <Widget>[
      CircleAvatar(child: Text('H'),
        backgroundColor: Colors.purpleAccent,),
      CircleAvatar(
        child: Text("S"),
        backgroundColor: Colors.green,

      )
    ],);

  }
  Future _avigadorPerfil(FirebaseUser user) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            Scaffold(
              body: UserAccountsDrawerHeader(
                accountName: Text(user.displayName),
                accountEmail: Text(user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  backgroundColor: Colors.white,
                ),
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    child: Text(user.displayName[0]),
                    backgroundColor: Colors.purpleAccent,
                  ),
                  CircleAvatar(
                    child: Text(user.displayName[1]),
                    backgroundColor: Colors.lightBlueAccent,
                  )
                ],
              ),
            )));
    Future _avigadorPerfilano(FirebaseUser user) async {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) =>
              Scaffold(
                body: UserAccountsDrawerHeader(
                  accountName: Text(user.displayName),
                  accountEmail: Text(user.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                    backgroundColor: Colors.white,
                  ),
                  otherAccountsPictures: <Widget>[
                    CircleAvatar(
                      child: Text(user.displayName[0]),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    CircleAvatar(
                      child: Text(user.displayName[1]),
                      backgroundColor: Colors.lightBlueAccent,
                    )
                  ],
                ),
              )));
      final drawerItems = ListView(children: <Widget>[
        ListTile(
            title: Text("Categorias"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirstRoute()),
              );
            }),
        ListTile(
            title: Text("Ayudas disponibles"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListadoAyudas()),
              );
            }),
        ListTile(
            title: Text("Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirebaseLogin()),
              );
            }),

        ListTile(
            title: Text("Chat"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FirebaseChatroom()),
              );
            }),
      ]);
    }
  }}