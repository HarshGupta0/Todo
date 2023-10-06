import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List items=[];
  @override
  void initState() {
    // TODO: implement initState
    FetchTodo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context,'/AddTodo');
          }, label: Text('Add Todo')),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    ));
  }
  Future<void>FetchTodo()async{
    final url ='https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri =Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode==200){
      final json= jsonDecode(response.body) as Map;
      final result= json["items"] as  List;
      setState(() {
        items=result;
      });
    }
    print(response.body);
    print(response.statusCode);

  }
}
