import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool isLoading = true;
  List items = [];
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
            Navigator.pushNamed(context, '/AddTodo');
          },
          label: Text('Add Todo')),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
            onRefresh: FetchTodo,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id=item['_id'] as String;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value){
                        if(value=='edit'){
                        //open and edit
                        }else if(value=='delete'){
                          //delete and remove the item
                        }
                      },
                      itemBuilder: (context){
                        return [
                          PopupMenuItem(child: Text('Edit'),
                            value: 'edit',
                          ),
                          PopupMenuItem(child: Text('Delete'),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                  );
                }
                )
        ),
      ),
    ));
  }
 Future<void> DeleteById( String id)async{
     final url ='https://api.nstack.in/v1/todos/$id';
     final uri = Uri.parse(url);
     final response=await http.delete(uri);
     if(response.statusCode==200){
       final filtered =items.where((element) => element['_id']!=id).toList();
       setState(() {
         items=filtered;
       });
     }else{
       ShowFailureMessage('Erorr Deleting');
     }

 }
  Future<void> FetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
    print(response.body);
    print(response.statusCode);
  }
  void ShowFailureMessage(String Message) {
    final snackBar = SnackBar(
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Message,style: TextStyle(fontSize: 22,color: Colors.white),),
            Icon(Icons.close),

          ],
        ),
      ),
      backgroundColor: Colors.red.shade200,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
