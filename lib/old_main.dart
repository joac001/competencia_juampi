import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// APP
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
  var selectedIndex = 1;

  void addSubject({
    required String name,
    required String dpto,
    required String description,
  }) {
    subjects.add(new Subject(
      name: name,
      dpto: dpto,
      description: description,
    ));
    notifyListeners();
  }
}

// PAGES
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
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
              appState.addSubject(
                name: 'Algebra II',
                dpto: 'Matematica',
                description: 'Hermosa materia',
              );
            },
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ),
        Expanded(
          child: List(),
        ),
      ],
    );
  }
}

class AddPage {
  Widget show() {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(20),
      ),
    );
  }
}

// WIDGETS
class List extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var subjects = appState.subjects;

    return ListView(
      children: [for (var subject in subjects) ListItem(subject: subject)],
    );
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
