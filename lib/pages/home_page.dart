import 'package:app/components/my_drawer.dart';
import 'package:app/pages/chat_page.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 //instance of auth
final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign out
  void signOut(){
//get auth service
  final authService = Provider.of<AuthService>(context , listen: false);

  authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ('Home Page'),
        backgroundColor: 
        Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      actions: [
        IconButton(
        onPressed:signOut,
        icon: const Icon(Icons.logout),
      ),
      ],
      ),
      drawer: MyDrawer(),
     body: _buildUserList(),
    );
  }
//list of users
    Widget _buildUserList(){
      return StreamBuilder <QuerySnapshot > 
      (stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text('error');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text('loading...');
        }
        return ListView(
        children: snapshot.data!.docs.map<Widget>(
          (doc)=>_buildUserListItem(doc)).toList(),
        );
      },);
    }
    //individual user list item
 Widget _buildUserListItem(DocumentSnapshot document){
Map<String, dynamic> data= document.data()! as Map<String,dynamic>;
  //display all users
 if (_auth.currentUser!.email != data['email']){
  return ListTile(
    title:Text( data ['username']),
    onTap: (){
      //pass the clicked user to the chat app
      Navigator.push
      (context, MaterialPageRoute(builder: 
      (context)=>ChatPage(
        receiverUserName: data['username'],
        receiverUserID:data ['uid'] ,
      ),
      ),
      );
    },
  );
 }else{
  //empty container
  return Container();
 }
  }
 }
