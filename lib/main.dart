import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todo/amplifyconfiguration.dart';
import 'package:todo/models/ModelProvider.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.orange)),
        home: const MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Todo?> todos = [];
  String input = "";

  Future<void> _configureAmplify() async {
    // Add any Amplify plugins you want to use
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    await Amplify.addPlugin(api);

    // You can use addPlugins if you are going to be adding multiple plugins
    // await Amplify.addPlugins([authPlugin, analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
      getTodos();
    } on AmplifyAlreadyConfiguredException {
      safePrint(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  @override
  void initState() {
    super.initState();
    // todos.add("Item1");
    _configureAmplify();
  }

  void getTodos() async {
    final todoRequest = ModelQueries.list(
      Todo.classType,
    );
    final todoResponse = await Amplify.API.query(request: todoRequest).response;

    if (todoResponse.hasErrors) {
      debugPrint(todoResponse.errors.toString());
    } else {
      setState(() {
        todos = todoResponse.data!.items;
      });
    }
  }

  Future<void> addTodo(String input) async {
    final todoRequest =
        ModelMutations.create(Todo(name: input, completed: false));
    final todoResponse =
        await Amplify.API.mutate(request: todoRequest).response;

    if (todoResponse.hasErrors) {
      debugPrint(todoResponse.errors.toString());
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${todoResponse.data?.name} başarıyla eklendi'),
        ),
      );

      getTodos();
    }

    setState(() {
      // todos.add(input);
    });
    Navigator.of(context).pop();
  }

  Future<void> deleteTodo(String id) async {
    final todoRequest = ModelMutations.deleteById(Todo.classType, id);
    final todoResponse =
        await Amplify.API.mutate(request: todoRequest).response;

    if (todoResponse.hasErrors) {
      debugPrint("Hata: ${todoResponse.errors.toString()}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${todoResponse.data?.name} başarıyla silindi."),
        ),
      );
      getTodos();
    }
  }

  Future<void> updateTodo(bool val) async {
    // Request
    // Response
    // completed true / false
    // has error has or not
    // getTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("mytodos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("add todolist"),
                content: TextField(onChanged: (String value) {
                  input = value;
                }),
                actions: <Widget>[
                  FloatingActionButton(
                      onPressed: () async {
                        addTodo(input);
                      },
                      child: const Text("Add")),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todos[index]!.id),
                onDismissed: (direction) {
                  setState(() {
                    todos.removeAt(index);
                  });
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(todos[index]!.name,
                        style: TextStyle(
                          decoration: (todos[index]!.completed == true)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        )),
                    trailing: SizedBox(
                      width: 96,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(
                                Icons.done,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteTodo(todos[index]!.id);
                              }),
                          IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteTodo(todos[index]!.id);
                              }),
                        ],
                      ),
                    ),
                  ),
                ));
          }),
    );
  }
}
