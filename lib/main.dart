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

  void add() {
    var i = new Subject(name: 'nombre', dpto: 'dpto', description: 'a');
    subjects.add(i);
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
    required this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    var theme = (Theme.of(context));

    return Card(
      color: theme.colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(
            Icons.note,
            size: 30,
            color: Colors.black38,
          ),
          title: Text(
            subject.getName(),
            style: TextStyle(fontSize: 20, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}

// CLASSES
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
