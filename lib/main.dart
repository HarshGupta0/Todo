import 'package:flutter/material.dart';
import 'package:todo/Screens/AddTodoPage.dart';
import 'package:todo/Screens/TodoListPage.dart';
void main(){
  runApp(Myapp());
}
class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      home: TodoPage(),
    );
  }
}
