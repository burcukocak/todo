import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.orange)),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List todos = [];
  String input = "";

  @override
  void initState() {
    super.initState();
    todos.add("Item1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("mytodos"),
      ),
      floatingActionButton:FloatingActionButton(onPressed:
       () {
        showDialog(context: context,
        builder:(BuildContext context) {
          return AlertDialog(
            title: Text("add todolist"),
            content: TextField(
              
              onChanged: (String value) {
                input = value;
              } ),
              actions: <Widget> [
              FloatingActionButton(
                onPressed: (){
setState(() {
  todos.add(input);
});
              },
              child: Text("Add")),
              
              ],
            );
           
       
          });
       } , child: Icon(Icon.add,color: Colors.white,),) ,
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
                  elevation: 4,
                  margin:EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius:
                 BorderRadius.circular(8) ),
                  child: ListTile(title: Text(todos[index]),
                trailing : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        todos.removeAt(index);
                      });
                    }),
                    

                ),
            ));
  }),
    );
}