import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMemo extends StatefulWidget {
  final Map? memo;

  const AddMemo({super.key, this.memo});

  @override
  State<AddMemo> createState() => _AddMemoState();
}

class _AddMemoState extends State<AddMemo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    final todo = widget.memo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((isEdit) ? "Update Memo" : "Add Memo"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: "Title", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  labelText: "Description", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 70),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  onPressed: () {
                    isEdit ? updatedata() : submitData();
                  },
                  child: Text(
                    isEdit ? "Update" : "Creat",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updatedata() async {
    final memo = widget.memo;
    final id = memo!['_id'];
    final isCompleted = memo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final responce = await http.put(uri,
        body: json.encode(body), headers: {'Content-Type': 'application/json'});
    if (responce.statusCode == 200) {
      showSnackBar("Memo Update");
      titleController.text = "";
      descriptionController.text = "";
    } else {
      print(responce.statusCode);
      print(responce.body);
      showSnackBar("Memo Not Update");
      titleController.text = "";
      descriptionController.text = "";
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final responce = await http.post(uri,
        body: json.encode(body), headers: {'Content-Type': 'application/json'});
    if (responce.statusCode == 201) {
      showSnackBar("Memo Created");
      titleController.text = "";
      descriptionController.text = "";
    } else {
      print(responce.statusCode);
      print(responce.body);
      showSnackBar("Memo Not Created");
      titleController.text = "";
      descriptionController.text = "";
    }
  }

  showSnackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
