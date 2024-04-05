import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memo/screen/create_memo.dart';

import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List memoList = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Text(" My Note"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(onPressed:fetchData, icon:Icon(Icons.refresh)),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            addMemo();
          },
          child: Text(
            "Add Memo",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
             itemCount: memoList.length,
            itemBuilder: (context, index) {
            final memo = memoList[index] as Map;
            final id = memo['_id'] as String;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              child: Text('${index+1}')),
            title: Text(memo['title']),
            subtitle: Text(memo['description']),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit') {
                 naviagateUpdatepage(memo);
                }
                else if (value == 'delete') {
                  deleteNote(id);
                }
              },

              itemBuilder: (BuildContext context) {
                return [
                PopupMenuItem(child: Text("Edit"),value: 'edit',),
                PopupMenuItem(child: Text("Delete"),value: 'delete',),
              ];
            },

            ),
          );
        }),
      )
    );
  }

  addMemo() {
    var route = MaterialPageRoute(builder: (context) => AddMemo());
    Navigator.push(context, route);
  }
 Future<void> deleteNote(String id)async{
   final URL = "https://api.nstack.in/v1/todos/$id";
   final uri = Uri.parse(URL);
   final responce  =await http.delete(uri);
   print(responce.statusCode);
    }


  Future<void>fetchData() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=15";
    final uri = Uri.parse(url);
    final responce = await http.get(uri);
    print(responce.body);
    if(responce.statusCode == 200){
      final json = jsonDecode(responce.body) as Map;
    final result = json['items'] as List;
    setState(() {
      memoList = result;
    });
    }
    else {
      print(responce.statusCode);
    }

  }

  void naviagateUpdatepage( Map memo) {
    Navigator.push(context,MaterialPageRoute(builder: (context)=>AddMemo(memo: memo)));
  }




}
