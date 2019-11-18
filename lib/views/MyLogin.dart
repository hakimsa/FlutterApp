import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/views/NavigatorDrw.dart';
import 'dart:async';
import 'package:flutter_app/views/firebase_constants.dart';

import 'package:flutter_app/views/main.dart';

import 'ListadoAyudas.dart';
import 'LoginUser.dart';

class FirebaseLogin extends StatefulWidget {
  const FirebaseLogin({Key key}) : super(key: key);

  @override
  _FirebaseLoginState createState() => _FirebaseLoginState();
}

class _FirebaseLoginState extends State<FirebaseLogin> {
  FirebaseUser _user;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    kFirebaseAuth.currentUser().then(
          (user) => setState(() => this._user = user),
        );
  }

  @override
  Widget build(BuildContext context) {
    final statusText = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _user == null
                    ? 'no estas logado: '
                    : 'estas logado como" "${_user.displayName}".',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: 31),
              ),
            ]));

    final googleLoginBtn = MaterialButton(
      color: Colors.blueAccent,
      child: Text('Log in with Google'),
      onPressed: this._busy
          ? null
          : () async {
              setState(() => this._busy = true);
              final user = await this._googleSignIn();
              this._avigadorPerfil(user);
              setState(() => this._busy = false);
            },
    );

    final anonymousLoginBtn = MaterialButton(
        color: Colors.deepOrange,
        child: Text('Log in anonymously'),
        onPressed: this._busy
            ? null
            : () async {
                setState(() => this._busy = true);
                await this._avigadorPerfilanoa();
                setState(() => this._busy = false);
              });

    final signOutBtn = FloatingActionButton(
      backgroundColor: Colors.amberAccent,
      child: Text('Log out'),
      foregroundColor: Colors.blueAccent,
      onPressed: this._busy
          ? null
          : () async {
              setState(() => this._busy = true);
              kFirebaseAuth.signOut();
              setState(() => this._busy = false);
            },
    );
    return Center(


        child:
          new Container(
            width:double.infinity,
            height: double.infinity,
            color: Colors.deepOrange,
            child: Container(
              child:new LoginFivePage() ,
              color: Colors.lightBlueAccent,

            ),

          ),



    );
  }

  // Sign in with Google.
  Future<FirebaseUser> _googleSignIn() async {
    final curUser = this._user ?? await kFirebaseAuth.currentUser();
    if (curUser != null && !curUser.isAnonymous) {
      print(curUser.toString());
      return curUser;
    }

    final googleUser = await kGoogleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Note: user.providerData[0].photoUrl == googleUser.photoUrl.
    final user = await kFirebaseAuth.signInWithCredential(credential);

    kFirebaseAnalytics.logLogin();
    setState(() => this._user = user);
    print(user.displayName);
    return user;
  }

  // Sign in Anonymously.
  Future<FirebaseUser> _anonymousSignIn() async {
    final curUser = this._user ?? await kFirebaseAuth.currentUser();
    if (curUser != null && curUser.isAnonymous) {
      return curUser;
    }

    kFirebaseAuth.signOut();
    final anonyUser = await kFirebaseAuth.signInAnonymously();
    final userInfo = UserUpdateInfo();
    print(anonyUser.uid);

    ;

    final user = await kFirebaseAuth.currentUser();
    kFirebaseAnalytics.logLogin();
    setState(() => this._user = user);
    return user;
  }

  Future<Null> _signOut() async {
    final user = await kFirebaseAuth.signInWithEmailAndPassword();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user == null
              ? 'No user logged in.'
              : '"${user.displayName}" logged out.',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );

    kFirebaseAuth.signOut();
    setState(() => this._user = null);
  }

  // Show user's profile in a new screen.
  Future _navigad4orPerfil(FirebaseUser user) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text('holas ${user.displayName}'),
          ),
          body: Column(
            children: <Widget>[
              Container(
                child: ListTile(
                  title: Text('Welcome : '),
                  trailing: user.photoUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        )
                      : CircleAvatar(
                          child: Text(" Welcom :" + user.displayName[0]),
                        ),
                ),
                color: Colors.white,
                width: 250,
                height: 150,
              ),
              ListTile(title: Text(': ${user.displayName}')),
              ListTile(
                title: Text('User id: ${user.uid}'),
                enabled: false,
                selected: true,
              ),
              ListTile(title: Text('Anonymous: ${user.isAnonymous}')),
              ListTile(title: Text('Email: ${user.email}')),
              ListTile(
                title: Text('Profile photo: '),
                trailing: user.photoUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user.photoUrl),
                      )
                    : CircleAvatar(
                        child: Text(" Welcom :" + user.displayName[0]),
                      ),
              ),
              ListTile(
                title: Text('Last sign in'),
                enabled: true,
              ),
              ListTile(title: Text('ProviderData: ${user.providerData}')),
            ],
          ),
        ),
      ),
    );
  }

  Future _avigadorPerfil(FirebaseUser user) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
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
          builder: (ctx) => Scaffold(
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
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("GaliBebe"),
        ),
        body: Center(child: Container(child: new MyStatefulWidget())),
        drawer: Drawer(
          child: drawerItems,
        ),
      );
    }
  }

// ignore: unused_element
  Future _avigadorPerfile(FirebaseUser user) {
    @override
    Widget build(BuildContext context) {
      final drawerHeader = UserAccountsDrawerHeader(
        accountName: Text(user.displayName),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
          backgroundColor: Colors.white,
        ),
        otherAccountsPictures: <Widget>[
          CircleAvatar(
            child: Text('H'),
            backgroundColor: Colors.purpleAccent,
          ),
          CircleAvatar(
            child: Text("S"),
            backgroundColor: Colors.green,
          )
        ],
      );

      final drawerItems = ListView(children: <Widget>[
        drawerHeader,
        ListTile(
            title: Text("Categorias"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirstRoute()),
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
            title: Text("Lista"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BeautifulAlertDialog()),
              );
            }),
        ListTile(
            title: Text("Animation"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BeautifulAlertDialog()),
              );
            }),
      ]);
      return drawerHeader;
    }
  }

  Future _avigadorPerfilanoa() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
              body: UserAccountsDrawerHeader(
                accountName: Text(" tes"),
                accountEmail: Text("Anom"),
                currentAccountPicture: CircleAvatar(
                  //backgroundImage: NetworkImage(user.photoUrl),

                  backgroundColor: Colors.white,
                ),
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    child: Text(""),
                    backgroundColor: Colors.purpleAccent,
                  ),
                  CircleAvatar(
                    child: Text("fgttt"[1]),
                    backgroundColor: Colors.lightBlueAccent,
                  )
                ],
              ),
            )));
  }
}

class BeautifulAlertDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return notificacionState();
  }
}

class notificacionState extends State<BeautifulAlertDialog> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: EdgeInsets.all(32.0),
      children: <Widget>[
        ////// Alert dialog.
        RaisedButton(
            color: Colors.red,
            child: Text('Alert Dialog'),
            onPressed: () {
              // The function showDialog<T> returns Future<T>.
              // Use Navigator.pop() to return value (of type T).
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Dialog title'),
                  content: Text(
                    'Sample alert',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                    ),
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.pop(context, 'OK'),
                    ),
                  ],
                ),
              ).then<String>((returnVal) {
                if (returnVal != null) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You clicked: $returnVal'),
                      action: SnackBarAction(label: 'OK', onPressed: () {}),
                    ),
                  );
                }
              });
            }),
        ////// Simple Dialog.
        RaisedButton(
          color: Colors.yellow,
          child: Text('Simple dialog'),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                title: Text('Dialog Title'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('user@example.com'),
                    onTap: () => Navigator.pop(context, 'user@example.com'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('user2@gmail.com'),
                    onTap: () => Navigator.pop(context, 'user2@gmail.com'),
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle),
                    title: Text('Add account'),
                    onTap: () => Navigator.pop(context, 'Add account'),
                  ),
                ],
              ),
            ).then<String>((returnVal) {
              if (returnVal != null) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You clicked: $returnVal'),
                    action: SnackBarAction(label: 'OK', onPressed: () {}),
                  ),
                );
              }
            });
          },
        ),
        ////// Time Picker Dialog.
        RaisedButton(
          color: Colors.green,
          child: Text('Time Picker Dialog'),
          onPressed: () {
            DateTime now = DateTime.now();
            showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
            ).then<TimeOfDay>((TimeOfDay value) {
              if (value != null) {
                // ignore: missing_return
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${value.format(context)}'),
                    action: SnackBarAction(label: 'OK', onPressed: () {}),
                  ),
                );
              }
            });
          },
        ),
        ////// Date Picker Dialog.
        RaisedButton(
          color: Colors.blue,
          child: Text('Date Picker Dialog'),
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2018),
              lastDate: DateTime(2025),
            ).then<DateTime>((DateTime value) {
              if (value != null) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Selected datetime: $value')),
                );
              }
            });
          },
        ),
        ////// Bottom Sheet Dialog.
        RaisedButton(
          color: Colors.orange,
          child: Text('Bottom Sheet'),
          onPressed: () {
            // Or: showModalBottomSheet(), with model bottom sheet, clicking
            // anywhere will dismiss the bottom sheet.
            showBottomSheet<String>(
              context: context,
              builder: (BuildContext context) => Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black12)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      title: Text('This is a bottom sheet'),
                    ),
                    ListTile(
                      dense: true,
                      title: Text('Click OK to dismiss'),
                    ),
                    ButtonTheme.bar(
                      // make buttons use the appropriate styles for cards
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]
          .map(
            (Widget button) => Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: button,
            ),
          )
          .toList(),
    );
  }
}
