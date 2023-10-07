import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  final Map? Todo;
  const AddTodo({Key? key,this.Todo}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  bool isEdit=false;
  TextEditingController titleController = new TextEditingController();
  TextEditingController DiscriptionController = new TextEditingController();
  @override
  void initState() {
    final Todo=widget.Todo;
    if(Todo!=null){
      final title=Todo['title'];
      final  discription=Todo['discription'];
      titleController.text=title;
      DiscriptionController.text=discription;
      isEdit=true;
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(isEdit?'Edit Todo':'Add Todo'),
            ),
            body: ListView(
              padding: EdgeInsets.all(20),
              children: [
                TextField(
                  controller: titleController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  maxLines: 8,
                  minLines: 2,
                ),
                TextField(
                  controller: DiscriptionController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Discription',
                  ),
                  maxLines: 8,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  keyboardAppearance: Brightness.dark,
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent.shade200),
                  onPressed: isEdit? UpdateData:submitData,
                  child: Text(
                   isEdit ? "Update":" Submit",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )));
  }
  Future<void> UpdateData()async{
    final Todo =widget.Todo;
    if(Todo==null){

    }
    final id=Todo['_id'];
    final title = titleController.text;
    final discription = DiscriptionController.text;
    final Body = {
      "title": title,
      "description": discription,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/$id';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(Body),
      headers: {'Content-Type': 'application/json'},
    );
  }
  Future<void> submitData() async {
//1. get data from form
    //2. sumit data to server
    //3. show errors if occcurs
    final title = titleController.text;
    final discription = DiscriptionController.text;

    final Body = {
      "title": title,
      "description": discription,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(Body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      titleController.text='';
      DiscriptionController.text='';
      print("Succesfully created");
      ShowSuccessMessage('Succesfully created');
      print(response.body);
      print(response.statusCode);
    } else {
      print("Error in Creation");
      ShowFailureMessage('Error in Creation');
    }
  }

  void ShowSuccessMessage(String Message) {
    final snackBar = SnackBar(
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Message,style: TextStyle(fontSize: 20,color: Colors.green.shade200),),
            Icon(Icons.check,color: Colors.white,),
          ],
        ),
      ),
      backgroundColor: Colors.green.shade300,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
