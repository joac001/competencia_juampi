import 'dart:js';
import 'dart:js_util';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Listado de materias',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF04345C)),
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var subjects = <Subject>[];

  void add() {
    var i = new Subject(name: 'nombre', dpto: 'dpto', description: 'a');
    subjects.add(i);
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var buttonStyle = ElevatedButton.styleFrom(
      primary: Color(0xFF1C72B8),
      onPrimary: Colors.white,
      elevation: 3,
      minimumSize: Size(160, 100),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: List(),
        ),
        Padding(
          padding: const EdgeInsets.all(80),
          child: ElevatedButton.icon(
            style: buttonStyle,
            onPressed: () {
              appState.add();
            },
            icon: Icon(
              Icons.add,
              size: 50,
            ),
            label: Text(
              'add',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class List extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var subjects = appState.subjects;

    return ListView(
      children: [
        for (var subject in subjects) ListItem(subject: subject),
      ],
    );
  }
}

class Subject {
  const Subject({
    required this.name,
    required this.dpto,
    required this.description,
  });

  final String name;
  final String dpto;
  final String description;

  String getName() => name;
  String getDpto() => dpto;
}

class ListItem extends StatelessWidget {
  const ListItem({
    required this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (Theme.of(context)).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(
            Icons.note,
            size: 30,
          ),
          title: Text(
            subject.getName(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
