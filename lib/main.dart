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
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xB91D023F)),
        ),
        home: HomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  static const historyLength = 5;
  late String selectedTerm;

  List<String> _searchHistory = <String>[];
  List<String> filteredSearchHistory = <String>[];

  var subject = Subject(name: 'a', dpto: 'c', description: 'b');
  var subjects = <Subject>[];
  var subjectsNames = <String>[];

  List<String> filterSearchTerms({required String? filter}) {
    if (filter != null && filter.isNotEmpty) {
      return (_searchHistory.reversed.where((term) => term.startsWith(filter)))
          .toList();
    } else {
      return (_searchHistory.reversed).toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
    } else {
      _searchHistory.add(term);
    }

    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
    notifyListeners();
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
    notifyListeners();
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  void addSubject({required Subject subject}) {
    subjects.add(subject);
    subjectsNames.add(subject.getName());
    notifyListeners();
  }

  void deleteSubject({required String name_, required String description_}) {
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].getName() == name_ &&
          subjects[i].getDescription() == description_) {
        subjects.removeAt(i);
        subjectsNames.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
}

// PAGES
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    //! DEBUG
    //appState.subjects.add(appState.subject);

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
          child: ListPage(),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
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

class SubjectAdderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    final Field subjectName = Field(title: 'Nombre de la materia');
    final Field dpto = Field(title: 'Departamento');
    final Field description = Field(title: 'Descripcion');

    var fields = <Field>[subjectName, dpto, description];

    return Dialog.fullscreen(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
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
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  subjectName,
                  dpto,
                  description,
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      onPressed: () => {
                        okPressed(
                          appState: appState,
                          context: context,
                          fields: fields,
                        ),
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
  SubjectInfoPage({
    required Subject this.subject,
  });

  final Subject subject;

  final deleteButton = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    fixedSize: Size(30, 30),
  );

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Dialog.fullscreen(
      child: Scaffold(
        body: Column(
          children: [
            SubjectInfoTitle(
              title: subject.getName(),
              appState: appState,
            ),
            SubjectInfo(subject: subject),
            ElevatedButton(
                onPressed: () => {
                      appState.deleteSubject(
                          name_: subject.getName(),
                          description_: subject.getDescription()),
                      Navigator.pop(context),
                    },
                child: Icon(Icons.delete,
                    size: 30, color: Theme.of(context).colorScheme.secondary))
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
      backgroundColor: Colors.grey,
      foregroundColor: Colors.black,
      side: BorderSide(width: 4, color: theme.colorScheme.inverseSurface),
      elevation: 0,
      minimumSize: Size(70, 70),
    );

    var otherButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: Colors.black,
      elevation: 3,
      minimumSize: Size(40, 40),
    );

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 65,
            child: Card(
              shape: RoundedRectangleBorder(),
              color: Colors.grey,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
                right: 10,
                left: 10,
                bottom: 10,
              ),
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
    var theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.5, top: 2.5, left: 30, right: 30),
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
          color: theme.colorScheme.secondary,
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
    required String this.title,
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
    required AppState this.appState,
  });

  final String title;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
