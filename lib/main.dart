import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<DataModel> createData(String name, String mess) async {
  var response = await http.post(
      Uri.parse('https://flutter-impact-api-demo.herokuapp.com/user'),
      headers: <String, String>{
        'Content-Type': 'Application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'message': mess,
      }));
  if (response.statusCode == 200) {
    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to Post");
  }
}

class DataModel {
  final String name;
  final String mess;

  const DataModel({required this.name, required this.mess});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      name: json['name'],
      mess: json['mess'],
    );
  }
  Map<String, dynamic> toJson() => {"name": name, "mess": mess};
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'HTTP Post Method'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messController = TextEditingController();
  var user = [];

  Future<DataModel>? _futureData;
  // var user = [];
  // var url = Uri.parse(
  //     'https://flutter-impact-api-demo.herokuapp.com/user'); // String web để response
  // void getUserFromAPI(String name, String mess) async {
  //   // goi http request
  //   var response = await http.get(url);
  //   var dataJson = jsonDecode(response.body);

  //   //hien snackbar
  //   const snackBar = SnackBar(
  //     content: Text('Yay! A SnackBar!'),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);

  //   //render ui
  //   setState(() {
  //     user = dataJson["listUser"];
  //   });
  // }

  // void postUserToAPI(name, mess) async {
  //   var response = await http.post(url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"Name": name, "Mess": mess}));
  //   if (response.statusCode == 200) {
  //     const snackBar = SnackBar(
  //       content: Text('Ban add user thanh cong'),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        backgroundColor: Color.fromARGB(255, 99, 179, 244),
        body: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints.expand(),
          color: Color.fromARGB(255, 72, 187, 249),
          child: (_futureData == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController messController = TextEditingController();
    Future<DataModel>? _futureData;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TextField(
          // controller: nameController,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
              labelText: "Name :",
              labelStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          controller: nameController,
        ),
        TextField(
          // controller: messController,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
              labelText: "Message :",
              labelStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          controller: messController,
        ),
        ElevatedButton(
          onPressed: () async {
            String name = nameController.text;
            String mess = messController.text;
            setState(() {
              _futureData = createData(name, mess);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<DataModel> buildFutureBuilder() {
    return FutureBuilder<DataModel>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.mess);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Container(
  //           height: 500,
  //           child: ListView.builder(
  //             itemCount: user.length,
  //             itemBuilder: (context, index) => Text(user[index].toString()),
  //           ),
  //         ),
  // Row(
  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   children: [
  //     ElevatedButton(
  //       onPressed: () => {postUserToAPI()},
  //       child: Text('Nut post user'),
  //     ),
  //     ElevatedButton(
  //       onPressed: () => {getUserFromAPI()},
  //       child: Text("Nut get user"),
  //     ),
  //   ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
