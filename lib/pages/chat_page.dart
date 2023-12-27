

import 'package:app/components/chat_bubble.dart';
import 'package:app/components/my_text_field.dart';
import 'package:app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
  required this.receiverUserEmail,
  required  this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController =TextEditingController();
  final ChatService _chatService =ChatService();
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  
  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
        widget.receiverUserID, _messageController.text
      );
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail),),
      body: Column(children: [
        //messages
        Expanded(child: _buildMessageList(),
        ),
        //user input
        _buildMessageInput(),
        const SizedBox(height: 25,)
      ]),
    );
  }
  //build msg list
Widget _buildMessageList(){
  return StreamBuilder(
    stream: _chatService.getMessages(
      widget.receiverUserID,
       _firebaseAuth.currentUser!.uid),
   builder: (context,snapshot){
    if(snapshot.hasError){
      return Text("Something went wrong!");
    }
    if(snapshot.connectionState == ConnectionState.waiting){
      return const Text('Loading...');
    }
    return ListView(
      children: snapshot.data!.docs.map((document) => 
      _buildMessageItem(document)).toList(),
    );
   });
}
  //build msg item
Widget _buildMessageItem(DocumentSnapshot document){
  Map<String , dynamic> data =document.data() as Map<String, dynamic>;
  
  //align the msg  to the right if the sender is the current user, ohterwise to the left
  var alignment =(data['senderId']==_firebaseAuth.currentUser!.uid)
  ? Alignment.centerRight
  :Alignment.centerLeft;
  return Container(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
          (data['senderId']== _firebaseAuth.currentUser!.uid)
          ?CrossAxisAlignment.end
          :CrossAxisAlignment.start,
          mainAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ?MainAxisAlignment.end
          : MainAxisAlignment.start,
        children: [
      Text(data['senderEmail']),
      const SizedBox(height: 5),
        ChatBubble(message: data['message'],)
      ],
      ),
    ),
  );
}
  //build msg input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(children: [
        Expanded(child: 
        MyTextField(
          controller: _messageController,
          hintText: 'Enter message',
          obscureText: false,
        ),),
        //send btn
        IconButton(onPressed: sendMessage,
         icon: const Icon(
          Icons.arrow_upward,size: 40,
         ))
      ],),
    );
  }
}