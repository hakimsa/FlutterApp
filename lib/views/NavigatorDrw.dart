import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_app/views/switcher.dart';

import 'dart:async';
import './firebase_constants.dart';
import 'DailogQuiz.dart';

class FirstRoute extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text('Categorias'),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              //clipper: WaveClipperTwo(),
              child: Container(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                height: 200,
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Selecciona  una category para emprezar ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      delegate: SliverChildBuilderDelegate(
                        _buildCategoryItem,
                        childCount: categories.length,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.deepPurpleAccent,
      textColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null) Icon(category.icon),
          if (category.icon != null) SizedBox(height: 5.0),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext)
      => BottomSheet(
        builder: (_) => QuizOptionsDialog(
          category: category,
        ),
        onClosing: () {},
      ),
    );
  }
}


class Category {
  final int id;
  final String name;
  final dynamic icon;
  Category(this.id, this.name, {this.icon});
}

class CheckAnswersPage extends StatelessWidget {
  //static final String path = "lib/src/pages/quiz_app/check_answers.dart";
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const CheckAnswersPage(
      {Key key, @required this.questions, @required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(' Detalles'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return RaisedButton(
        child: Text("Done"),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => QuizOptionsDialog()));
        },
      );
    }
    Question question = questions[index];
    bool correct = question.correctAnswer == answers[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question.question,
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              "${answers[index]}",
              style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "Answer: "),
                      TextSpan(
                          text: question.correctAnswer,
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }

  WaveClipperTwo() {
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
}

enum Type { multiple, boolean }

enum Difficulty { easy, medium, hard }

class Question {
  final String categoryName;
  final Type type;
  final Difficulty difficulty;
  final String question;
  final String correctAnswer;
  final List<dynamic> incorrectAnswers;

  Question(
      {this.categoryName,
      this.type,
      this.difficulty,
      this.question,
      this.correctAnswer,
      this.incorrectAnswers});

  Question.fromMap(Map<String, dynamic> data)
      : categoryName = data["category"],
        type = data["type"] == "ayudas" ? Type.multiple : Type.boolean,
        difficulty = data["difficulty"] == "easy"
            ? Difficulty.easy
            : data["difficulty"] == "medium"
                ? Difficulty.medium
                : Difficulty.hard,
        question = data["question"],
        correctAnswer = data["correct_answer"],
        incorrectAnswers = data["incorrect_answers"];

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromMap(question)).toList();
  }
}

class QuizPage extends StatefulWidget {
//  static final String path = "lib/src/pages/quiz_app/quiz_page.dart";
  final List<Question> questions;
  final Category category;

  const QuizPage({Key key, @required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(widget.category.name),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              // clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex + 1}"),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          widget.questions[_currentIndex].question,
                          softWrap: true,
                          style: _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...options.map((option) => RadioListTile(
                              title: Text("$option"),
                              groupValue: _answers[_currentIndex],
                              value: option,
                              onChanged: (value) {
                                setState(() {
                                  _answers[_currentIndex] = option;
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text(
                            _currentIndex == (widget.questions.length - 1)
                                ? "Submit"
                                : "Seguiente"),
                        onPressed: _nextSubmit,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("Elige una opcion para seguir."),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("Estas seguro de salir?  se pierde todo el proceso de busqueda."),
            title: Text("Warning!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Si"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}

const Map<int, dynamic> respuestas = {
  0: "ayuda por discapacidad",
  1: 1,
  2: "checke bebe",
  3: "ayudas",
  4: "Estilo de vida ",
  5: "Noticias",
  6: "Buscador ",
  7: "True",
  8: "Jakarta"
};

final List<Category> categories = [
  Category(9, "Ayudas publicas Galicia", icon: Icons.help),
  Category(10, "Ayudas sociales", icon: Icons.search),
  Category(11, "Programas de apuyo", icon: Icons.settings),
  Category(12, "Buscar beca", icon: Icons.satellite),
  Category(13, " Eventos Musicaless & Theatros", icon: Icons.art_track),
  Category(14, "Promciones Especiales", icon: Icons.tv),
  Category(15, "Noticia", icon: Icons.gamepad),
  Category(16, "Orientaciones sociales", icon: Icons.school),
  Category(21, "Sports", icon: Icons.card_travel),
  Category(22, "Geography", icon: Icons.developer_mode),
  Category(23, "History", icon: Icons.donut_small),
  Category(24, "Politics"),
];

final List<Question> ayudas_disponibles = Question.fromData([
  {
    "category": "ayudas",
    "type": "multiple",
    "difficulty": "easy",
    "question": " Número de Hijos ",
    "correct_answer": "1",
    "incorrect_answers": ["2", "3", "Mas"]
  },
  {
    "category": "ayudas",
    "type": "multiple ",
    "difficulty": "easy",
    "question": " Renta?",
    "correct_answer": "1800",
    "incorrect_answers": [
      "1800",
      "2000",
      "+2000",
    ]
  },
  {
    "category": "ayudas",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Part Multiple",
    "correct_answer": "Si",
    "incorrect_answers": [
      "No",
    ]
  },
  {
    "category": "ayudas",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Hijos con discapacidad ?",
    "correct_answer": "si",
    "incorrect_answers": [
      "no",
    ]
  },
  {
    "category": "ayudas ",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Tipo familia?",
    "correct_answer": "pareja",
    "correct_answer": "monoparental",
    "incorrect_answers": [" Pareja de hecho", "Monoparental", " Madre soltera "]
  },
  {
    "category": "ayudas",
    "type": "boolean",
    "difficulty": "easy",
    "question": "Parto múltiple***",
    "correct_answer": "si",
    "incorrect_answers": ["no"]
  },
  {
    "category": "ayudas",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Progenitor  con discapacidad ?",
    "correct_answer": "si",
    "incorrect_answers": [
      "no",
    ]
  }
]);





class SchoolList extends StatefulWidget {
  SchoolList({Key key}) : super(key: key);
  _SchoolListState createState() => _SchoolListState();
}

class _SchoolListState extends State<SchoolList> {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

  final List<Map> schoolLists = [
    {
      "name": "Hakim samouh",
      "location": "572 Statan NY, 12483",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2019/07/06/20/06/drops-4321147_960_720.jpg"
    },
    {
      "name": "Xaviers International",
      "location": "234 Road Kathmandu, Nepal",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2019/07/06/20/06/drops-4321147_960_720.jpg"
    },
    {
      "name": "Kinder Garden",
      "location": "572 Statan NY, 12483",
      "type": "Play Group School",
      "logoText":
          "https://cdn.pixabay.com/photo/2013/08/28/12/03/plumage-176723_960_720.jpg"
    },
    {
      "name": "WilingTon Cambridge",
      "location": "Kasai Pantan NY, 12483",
      "type": "Lower Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2013/08/28/12/03/plumage-176723_960_720.jpg"
    },
    {
      "name": "Fredik Panlon",
      "location": "572 Statan NY, 12483",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"
    },
    {
      "name": "Whitehouse International",
      "location": "234 Road Kathmandu, Nepal",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/01/31/13/14/animal-2023924_960_720.png"
    },
    {
      "name": "Haward Play",
      "location": "572 Statan NY, 12483",
      "type": "Play Group School",
      "logoText":
          "https://cdn.pixabay.com/photo/2016/06/09/18/36/logo-1446293_960_720.png"
    },
    {
      "name": "Campare Handeson",
      "location": "Kasai Pantan NY, 12483",
      "type": "Lower Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: schoolLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Institutes",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          //controller: TextEditingController(text: location[0]),
                          cursorColor: Theme.of(context).primaryColor,
                          style: dropdownMenuItem,
                          decoration: InputDecoration(
                              hintText: "Search School",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                elevation: 0.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: secondary),
              image: DecorationImage(
                  image: NetworkImage(schoolLists[index]['logoText']),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  schoolLists[index]['name'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(schoolLists[index]['location'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.insert_emoticon,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(schoolLists[index]['type'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AnimationOneDetails extends StatelessWidget {
  //static final String path = "lib/src/pages/animations/animation1/details.dart";
  final int index;

  const AnimationOneDetails({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: "image$index",
              child: Image.asset(images[index], fit: BoxFit.cover)),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                IconButton(
                  color: Colors.white,
                  icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Spacer(),
                SizedBox(height: 10.0),
                Hero(
                  tag: "title$index",
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      dummy[index]["title"],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Hero(
                  tag: "price$index",
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      dummy[index]['price'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}

const List<String> images = [
  "https://pixabay.com/es/photos/gotas-agua-roc%C3%ADo-macro-hierba-4321147/",
  "https://pixabay.com/es/photos/gotas-agua-roc%C3%ADo-macro-hierba-4321147/",
  "https://pixabay.com/es/photos/gotas-agua-roc%C3%ADo-macro-hierba-4321147/",
];

const List<Map> dummy = [
  {"title": "Beautiful Cardigan", "price": "\$600"},
  {"title": "Leather Bag", "price": "\$400"},
  {"title": "White Beautiful Bag", "price": "\$350"},
];

class CartOnePage extends StatelessWidget {
  static final String path = "lib/src/pages/ecommerce/cart1.dart";
  final List<Map> items = [
    {
      "image": "assets/Background.jpg",
      "title": "Tagin de carne y cuerlas ",
      "price": 20
    },
    {"image": "assets/grimace.png", "title": "Pastela de pollo ", "price": 30},
    {
      "image": "assets/grimace.png",
      "title": "Pastela de Pescado ",
      "price": 25
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                child: Text(
                  "Welcome to Mediterraneo-Food ",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700),
                )),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          elevation: 3.0,
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 80,
                                  child: Image.asset(items[index]["image"]),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        items[index]["title"],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        "\$${items[index]['price']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 35,
                        child: Container(
                          height: 25,
                          width: 20,
                          alignment: Alignment.center,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            padding: EdgeInsets.all(0.0),
                            color: Colors.pinkAccent,
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Subtotal      50€",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Envio       05€",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Total a pagar     55€",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      height: 50.0,
                      color: Colors.deepPurpleAccent,
                      child: Text(
                        "Realizar el pago ".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FirebaseChatroom extends StatefulWidget {
  const FirebaseChatroom({Key key}) : super(key: key);

  @override
  _FirebaseChatroomState createState() => _FirebaseChatroomState();
}

class _FirebaseChatroomState extends State<FirebaseChatroom> {
  DatabaseReference _firebaseMsgDbRef;

  FirebaseUser _user;
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc();
    this._firebaseMsgDbRef =
        kFirebaseDbRef.child('chats/${now.year}/${now.month}/${now.day}');
    kFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this._user = user;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          icon: Icon(Icons.info),
          onPressed: () => _showNoteDialog(context),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(_user == null
              ? 'Chatting'
              : 'Chatting as "${_user.displayName}"'),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _buildMessagesList(),
            Divider(height: 2.0),
            _buildComposeMsgRow()
          ],
        ),
      ),
    );
  }

  void _showNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Nota'),
        content: Text('Hola.\n\n'
            'The chat messages are publicly available, and they '
            'can be deleted at any time by the admin.\n\n'
            'To send messages, you must log in '
            'in the "GaliBebe login" '),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  // Builds the list of chat messages.
  Widget _buildMessagesList() {
    return Flexible(
      child: Scrollbar(
        child: FirebaseAnimatedList(
          query: _firebaseMsgDbRef,
          sort: (a, b) => b.key.compareTo(a.key),
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (BuildContext ctx, DataSnapshot snapshot,
                  Animation<double> animation, int idx) =>
              _messageFromSnapshot(snapshot, animation),
        ),
      ),
    );
  }

  // Returns the UI of one message from a data snapshot.
  Widget _messageFromSnapshot(
      DataSnapshot snapshot, Animation<double> animation) {
    final String senderName = snapshot.value['senderName'] ?? '?? <unknown>';
    final String msgText = snapshot.value['text'] ?? '??';
    final sentTime = snapshot.value['timestamp'] ?? '<unknown timestamp>';
    final String senderPhotoUrl = snapshot.value['senderPhotoUrl'];
    final messageUI = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: senderPhotoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(senderPhotoUrl),
                  )
                : CircleAvatar(
                    child: Text(senderName[0]),
                  ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(senderName, style: Theme.of(context).textTheme.subhead),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(sentTime).toString(),
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(msgText),
              ],
            ),
          ),
        ],
      ),
    );
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: messageUI,
    );
  }

  // Builds the row for composing and sending message.
  Widget _buildComposeMsgRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: TextField(
              keyboardType: TextInputType.multiline,
              // Setting maxLines=null makes the text field auto-expand when one
              // line is filled up.
              maxLines: null,
              maxLength: 200,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
              controller: _textController,
              onChanged: (String text) =>
                  setState(() => _isComposing = text.length > 0),
              onSubmitted: _onTextMsgSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing
                ? () => _onTextMsgSubmitted(_textController.text)
                : null,
          ),
        ],
      ),
    );
  }

  // Triggered when text is submitted (send button pressed).
  Future<Null> _onTextMsgSubmitted(String text) async {
    // Make sure _user is not null.
    if (this._user == null) {
      this._user = await kFirebaseAuth.currentUser();
    }
    if (this._user == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Login required'),
          content: Text('Registarte para Enviar Mensajes.\n\n'
              'Go to the "GaliApp login" , and log in from there. '
              'You will then be able to send messages.  Gracias'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
      return;
    }
    // Clear input text field.
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    // Send message to firebase realtime database.
    _firebaseMsgDbRef.push().set({
      'senderId': this._user.uid,
      'senderName': this._user.displayName,
      'senderPhotoUrl': this._user.photoUrl,
      'text': text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    kFirebaseAnalytics.logEvent(name: 'send_message');
  }
}
class QuizFinishedPage extends StatelessWidget {
  static final String path = "lib/src/pages/quiz_app/quiz_finished.dart";
  final List<Question> questions;
  final Map<int, dynamic> answers;

  QuizFinishedPage({Key key, @required this.questions, @required this.answers}): super(key: key) {

  }

  @override
  Widget build(BuildContext context){
    int correct = 0;
    this.answers.forEach((index,value){
      if(this.questions[index].correctAnswer == value)
        correct++;
    });
    final TextStyle titleStyle = TextStyle(
        color: Colors.black87,
        fontSize: 16.0,
        fontWeight: FontWeight.w500
    );
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Result'),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.pink
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Total Questions", style: titleStyle),
                  trailing: Text("${questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Score", style: titleStyle),
                  trailing: Text("${correct/questions.length * 100}%", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Correct Answers", style: titleStyle),
                  trailing: Text("$correct/${questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Incorrect Answers", style: titleStyle),
                  trailing: Text("${questions.length - correct}/${questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.pink.withOpacity(0.8),
                    textColor: Colors.white,
                    child: Text("Goto Home"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.deepPurple.withOpacity(0.8),
                    textColor: Colors.white,
                    child: Text("Check Answers"),
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(questions: questions, answers: answers,)
                      ));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
