import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Crud',
      home: const MyHomePage(title: 'Firestore CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final FirebaseFirestore  _firestore = FirebaseFirestore.instance;
  static final _CollectionReference = _firestore.collection("Users").doc("UsersInfo").collection("Profile");
  static final _DocumentReference = _CollectionReference.doc('ProfileInfo');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: ()=> addData(), child: Text("Add Data")),
            TextButton(onPressed: ()=> readData(), child: Text("Read Data")),
            TextButton(onPressed: ()=> updateData(), child: Text("Update Data")),
            TextButton(onPressed: ()=> deleteData(), child: Text("Delete Data")),
          ],
        ),
      ),
    );
  }

  addData() async{
    Map<String,dynamic> demoData = {
      "Name": "Saral",
      "Email":"Saraljain52@gmail.com"
    };
    _DocumentReference.set(demoData)
        .whenComplete(() => Fluttertoast.showToast(msg: "User Added"))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  readData() async {
    var documentsnapshot = await  _CollectionReference.doc("ProfileInfo").get();
    if(documentsnapshot.exists){
      Map<String,dynamic>? data = documentsnapshot.data();
      Fluttertoast.showToast(msg: data?['Name']);
    }
  }
   updateData()async{
     Map<String,dynamic> demoData = {
       "Name": "Saral Jain",
     };
     _DocumentReference.update(demoData)
         .whenComplete(() => Fluttertoast.showToast(msg: "User Updated"))
         .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
   }
   deleteData() async{
    _DocumentReference.delete().
        whenComplete(() => Fluttertoast.showToast(msg: "User Deleted"))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
   }



}
