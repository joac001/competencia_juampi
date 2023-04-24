import 'dart:html';

import 'package:easy_search_bar/easy_search_bar.dart';
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
  var subjectsNames = <String>[];

  void addSubject({required Subject subject}) {
    subjects.add(subject);
    updateSubjectNames();
    updateDptos();
    notifyListeners();
  }

  void updateSubjectNames() {
    for (Subject subject in this.subjects) {
      this.subjectsNames.add(subject.getName());
    }
  }

  List<String> updateDptos() {
    var dptos = <String>[];
    for (Subject subject in this.subjects) {
      if (!subjectsNames.contains(subject.dpto)) {
        dptos.add(subject.dpto);
      }
    }
    return dptos;
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
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    appState.updateSubjectNames();
    var subjectsNames = appState.subjectsNames;
    var dptos = appState.updateDptos();

    var suggestions = subjectsNames + dptos;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            appBar: EasySearchBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text('Buscar'),
              searchHintText: 'Busca por materia o departamento',
              suggestions: suggestions,
              onSearch: (value) => search(value: value, matching: suggestions),
            ),
          ),
        ),
      ],
    );
  }

  void search({required String value, required List<String> matching}) {
    var matcher = <String>[];

    for (String match in matching) {
      matcher.add(match.toLowerCase());
    }
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
                      child: Icon(
                        Icons.arrow_back,
                        size: 40,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 40),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
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
                child: Icon(
                  Icons.check,
                  size: 40,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  minimumSize: Size(50, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void okPressed(
      {required AppState appState, required context, required List fields}) {
    if (!(appState.subjectsNames).contains(fields[0])) {
      if (fields[0].data == '' || fields[1].data == '') {
        showError(
          context: context,
          error: '¡Debes ingresar un nombre y departameno para la materia!',
        );
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
    } else {
      showError(context: context, error: '¡Esta materia ya esta guardada!');
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
      {required context, required String error}) {
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
          child: Text(
            error,
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
      side: BorderSide(width: 5, color: Colors.white),
      elevation: 0,
      maximumSize: Size(85, 85),
      minimumSize: Size(85, 85),
    );

    var otherButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      minimumSize: Size(55, 55),
    );

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Card(
              shape: RoundedRectangleBorder(),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: otherButtonStyle,
                onPressed: () => {appState.changeActivePage(key: 0)},
                child: Icon(
                  Icons.list,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: otherButtonStyle,
                onPressed: () => {appState.changeActivePage(key: 1)},
                child: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
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
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(title),
      centerTitle: true,
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
