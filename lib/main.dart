import 'dart:js_util';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listado de materias',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF04345C)),
      ),
      home: HomePage(subjectListInstance: SubjectList()),
    );
  }
}

// PAGES
class HomePage extends StatelessWidget {
  HomePage({
    required this.subjectListInstance,
  });

  final SubjectList subjectListInstance;

  @override
  Widget build(BuildContext context) {
    var theme = (Theme.of(context));

    var buttonStyle = ElevatedButton.styleFrom(
      primary: theme.colorScheme.primary,
      onPrimary: theme.colorScheme.inversePrimary,
      elevation: 3,
      minimumSize: Size(80, 80),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(80),
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectAdderPage(
                      subjectListInstance: subjectListInstance),
                ),
              );
              print(subjectListInstance.subjects.length);
            },
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ),
        Expanded(
          child: subjectListInstance,
        ),
      ],
    );
  }
}

class SubjectAdderPage extends StatelessWidget {
  const SubjectAdderPage({
    required SubjectList this.subjectListInstance,
  });

  final SubjectList subjectListInstance;

  @override
  Widget build(BuildContext context) {
    Field subjectName = Field(title: 'Nombre de la materia');
    Field dpto = Field(title: 'Departamento');
    Field description = Field(title: 'Descripcion');

    var fields = <Field>[subjectName, dpto, description];
    var data = <String>[];

    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Icon(Icons.arrow_back),
                    style: ElevatedButton.styleFrom(minimumSize: Size(40, 40)),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          subjectName,
          dpto,
          description,
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: () => {
                for (Field field in fields) {data.add(field.data)},
                subjectListInstance.addSubject(
                  subject: new Subject(
                      name: data[0], dpto: data[1], description: data[2]),
                ),
                print(subjectListInstance.subjects.length)
              },
              child: Icon(Icons.check),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                minimumSize: Size(50, 45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGETS
class SubjectList extends StatelessWidget {
  SubjectList _subjectList = SubjectList();

  var subjects = <Subject>[];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [for (var subject in subjects) ListItem(subject: subject)],
    );
  }

  void addSubject({required Subject subject}) {
    subjects.add(subject);
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    required Subject this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    var theme = (Theme.of(context));

    return Card(
      color: theme.colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(width: 50),
            Text(
              subject.getName(),
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            SizedBox(width: 50),
            ElevatedButton(
              onPressed: () => print(''),
              child: Icon(Icons.description),
            ),
          ],
        ),
      ),
    );
  }
}

class Field extends StatelessWidget {
  Field({
    super.key,
    required this.title,
  });

  final String title;

  String data = '';

  Widget build(BuildContext build) {
    var boxDecoration = InputDecoration(
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3)),
      hintText: title,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
      child: TextField(
        onChanged: (input) => {setData(input: input)},
        decoration: boxDecoration,
      ),
    );
  }

  void setData({required String input}) {
    this.data = input;
  }
}

// CLASSES
class Subject {
  const Subject({
    required String this.name,
    required String this.dpto,
    required String this.description,
  });

  final String name;
  final String dpto;
  final String description;

  String getName() => name;
  String getDpto() => dpto;
  String getDescription() => description;
}
