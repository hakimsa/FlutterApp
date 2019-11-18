import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ListadoAyudas.dart';
import 'NavigatorDrw.dart';
import 'Registarte.dart';
import 'firebase_constants.dart';

import 'main.dart';

class LoginFivePage extends StatefulWidget {
  const LoginFivePage({Key key}) : super(key: key);
  @override
  _LoginFivePageState createState() => _LoginFivePageState();
}

class _LoginFivePageState extends State<LoginFivePage> {
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
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blueAccent, Color(0x21fe424d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white, Colors.lightBlueAccent])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Icon(
                        Icons.child_care,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "GaliBebe Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 30),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlueAccent])),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                onChanged: (String value) {},
                cursorColor: Colors.lightBlueAccent,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Colors.lightBlue,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                onChanged: (String value) {},
                cursorColor: Colors.purple,
                decoration: InputDecoration(
                    hintText: "Contraseña",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Colors.lightBlue,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.lightBlueAccent),
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                ),
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 30.5),
                alignment: Alignment(40, 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.deepOrangeAccent),
                child: FlatButton.icon(
                    icon: Image.asset(
                      'assets/images/Google.ico',
                      width: 20,
                      height: 30,
                    ),
                    label: Text(
                      "Login con Google",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 31),
                    ),
                    onPressed: () {
                      //login con google  falta hacerlo asyncrono cuado si loga o desloga
                      _googleSignIn();
                      this._avigadorPerfil(_user);
                    }),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "FORGOT PASSWORD ?",
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Don't have an Account ? ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                "Sign Up ",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    decoration: TextDecoration.underline),
              ),
            ],
          )
        ],
      ),
    );
  }

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

  Future _avigadorPerfil(FirebaseUser user) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.blueGrey,
                child: ListadoAyudas(),
              )),
          backgroundColor: Colors.white,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: Text("Menu"),
          ),
          drawer: Drawer(
              child: ListView(
            children: <Widget>[
              Container(
                child: ListTile(
                  title: Text('Welcome : ' + user.displayName,
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w900,
                          fontSize: 15)),
                  subtitle: Text(
                    user.email,
                  ),
                  trailing: user.photoUrl != null
                      ? CircleAvatar(
                          maxRadius: 40,
                          minRadius: 40,
                          backgroundImage: NetworkImage(user.photoUrl),
                        )
                      : CircleAvatar(
                          child: Text(" Welcom :" + user.displayName[0]),
                        ),
                ),
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.lightBlueAccent,
                      blurRadius: 13.0,
                    ),
                  ],
                ),
                width: 250,
                height: 150,
              ),
              Card(
                child: ListTile(
                    title: Text(
                      "Categorias ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          decoration: TextDecoration.underline),
                    ),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Icon(Icons.category),
                    ]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FirstRoute()),
                      );
                    }),
                color: Colors.lightBlueAccent,
              ),
              Card(
                child: ListTile(
                    title: Text("Ayudas disponibles",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            decoration: TextDecoration.underline)),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Icon(Icons.live_help),
                    ]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListadoAyudas()),
                      );
                    }),
                color: Colors.lightBlueAccent,
              ),
              Card(
                child: ListTile(
                    title: Text("Contact",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            decoration: TextDecoration.underline)),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Icon(Icons.contacts),
                    ]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyStatefulWidget()),
                      );
                    }),
                color: Colors.lightBlueAccent,
              ),
              Card(
                child: ListTile(
                    title: Text("Chat",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            decoration: TextDecoration.underline)),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Icon(Icons.chat),
                    ]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FirebaseChatroom()),
                      );
                    }),
                color: Colors.lightBlueAccent,
              ),
              Card(
                child: ListTile(
                    title: Text("Cerrar session",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            decoration: TextDecoration.underline)),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.white,
                      ),
                    ]),
                    onTap: () async {
                      final user = await kFirebaseAuth.signOut();
                      kFirebaseAuth.signOut();

                      setState(() => this._user = null);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginFivePage()),
                      );
                    }),
                color: Colors.lightBlueAccent,
              ),
            ],
          ) // Populate the Drawer in the next step.
              ),
        ),
      ),
    );
  }
}

class AnimationToolkit {
  // ...
  static const FloatingActionButtonAnimator floatingButtonAnimator =
      _FloatingButtonAnimator();
}

class _FloatingButtonAnimator extends FloatingActionButtonAnimator {
  const _FloatingButtonAnimator();

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 8, end: 11.0).animate(parent);
  }

  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    return end;
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .9, size.height - 40);
    var firstControlPoint = Offset(size.width * .45, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 60);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
