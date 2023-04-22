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
      home: HomePage(),
    );
  }
}

// PAGES
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = (Theme.of(context));

    var buttonStyle = ElevatedButton.styleFrom(
      primary: theme.colorScheme.primary,
      onPrimary: theme.colorScheme.inversePrimary,
      elevation: 3,
      minimumSize: Size(80, 80),
    );

    SubjectList subjectList = SubjectList();

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
                    builder: (context) => SubjectAdderPage(),
                  ));
            },
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ),
        Expanded(
          child: subjectList,
        ),
      ],
    );
  }
}

class SubjectAdderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

// WIDGETS
class SubjectList extends StatelessWidget {
  var subjects = <Subject>[];
  @override
  Widget build(BuildContext context) {
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
