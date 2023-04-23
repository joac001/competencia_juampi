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
      create: (context) => AppState(),
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

class AppState extends ChangeNotifier {
  var subjects = <Subject>[];

  void addSubject({required Subject subject}) {
    subjects.add(subject);
    notifyListeners();
  }
}

// PAGES
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = (Theme.of(context));

    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.inversePrimary,
      elevation: 3,
      minimumSize: Size(80, 80),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 50,
        ),
        Expanded(
          child: SubjectList(),
        ),
        Padding(
          padding: const EdgeInsets.all(80),
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectAdderPage(),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class SubjectAdderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    final Field subjectName = Field(title: 'Nombre de la materia');
    final Field dpto = Field(title: 'Departamento');
    final Field description = Field(title: 'Descripcion');

    var fields = <Field>[subjectName, dpto, description];

    return Dialog(
      child: Scaffold(
        body: Column(
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
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(40, 40)),
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
                  okPressed(
                      appState: appState, context: context, fields: fields),
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
      ),
    );
  }

  void okPressed({required appState, required context, required List fields}) {
    if (fields[0].data == '' || fields[1].data == '') {
      showError(context: context);
    } else {
      appState.addSubject(
          subject: new Subject(
        name: fields[0].data,
        dpto: fields[1].data,
        description: fields[1].data,
      ));
      Navigator.pop(context);
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
      {required context}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(20),
          height: 90,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: const Text(
            '¡Debes ingresar un nombre y departameno para la materia!',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}

// WIDGETS
class SubjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
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

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 2.5, top: 2.5, left: 30, right: 30),
      child: Card(
        color: theme.colorScheme.inversePrimary,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
