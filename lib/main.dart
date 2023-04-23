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
  Widget activePage = ListPage();
  var subjects = <Subject>[];

  void addSubject({required Subject subject}) {
    subjects.add(subject);
    notifyListeners();
  }

  void changeActivePage({required int key}) {
    switch (key) {
      case 0:
        activePage = ListPage();
        break;
      case 1:
        activePage = SearchPage();
        break;
    }
    notifyListeners();
  }
}

// PAGES
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    Widget activePage = appState.activePage;

    double navBarHeight = 100;

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - navBarHeight,
          child: activePage,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: navBarHeight,
          child: NavBar(),
        ),
      ],
    );
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
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
    } else if (fields[2].data == '') {
      appState.addSubject(
          subject: new Subject(
        name: fields[0].data,
        dpto: fields[1].data,
        description: 'Sin descripcion',
      ));
      Navigator.pop(context);
    } else {
      appState.addSubject(
          subject: new Subject(
        name: fields[0].data,
        dpto: fields[1].data,
        description: fields[2].data,
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

class SubjectInfoPage extends StatelessWidget {
  const SubjectInfoPage({
    required Subject this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Icon(Icons.arrow_back),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SubjectInfoTitle(title: subject.getName()),
            SubjectInfo(subject: subject),
          ],
        ),
      ),
    );
  }
}

// WIDGETS
class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    var theme = Theme.of(context);

    var addButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.inversePrimary,
      elevation: 3,
      minimumSize: Size(80, 80),
    );

    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 3,
      minimumSize: Size(55, 55),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () => {appState.changeActivePage(key: 0)},
            child: Icon(
              Icons.list,
              size: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () => {appState.changeActivePage(key: 1)},
            child: Icon(
              Icons.search,
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: ElevatedButton(
            style: addButtonStyle,
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
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectInfoPage(subject: subject),
            ),
          )
        },
        child: Card(
          color: theme.colorScheme.inversePrimary,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    subject.getName(),
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                ),
              ],
            ),
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

class SubjectInfo extends StatelessWidget {
  const SubjectInfo({
    required Subject this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Departamento:',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Text(
            subject.getDpto(),
            style: TextStyle(fontSize: 20),
          ),
        ),
        Text(
          'Descripcion:',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Text(
            subject.getDescription(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class SubjectInfoTitle extends StatelessWidget {
  const SubjectInfoTitle({
    required String this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// DATA STRUCTURE
class Subject {
  Subject({
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
