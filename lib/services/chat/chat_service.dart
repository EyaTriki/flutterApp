import 'package:app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{
// instance of auth and firestore
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

// send msg
Future <void> sendMessage(String receiverId, String message) async{
  // get current user info
  final String currUserId = _firebaseAuth.currentUser!.uid;
  final String currUserEmail = _firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp = Timestamp.now();
  //create a new msg
  Message newMessage =Message(
  senderId: currUserId, 
  senderEmail: currUserEmail,
   receiverId: receiverId, 
   message: message, 
   timestamp: timestamp);

//construct chat room id
List<String> ids = [currUserId, receiverId];
ids.sort();
String chatRoomId =ids.join("_");//combiner les ids en uns seule chaine as chatroomId

//add new msg to db
await _fireStore
.collection('chat_rooms')
.doc(chatRoomId)
.collection('messages')
.add(newMessage.toMap());
}

//get msg
Stream <QuerySnapshot> getMessages(String userId, String otherUserId){
//chat room id from user ids
List<String> ids = [userId, otherUserId];
ids.sort();
String chatRoomId=ids.join("_");
return _fireStore
.collection('chat_rooms')
.doc(chatRoomId)
.collection('messages')
.orderBy('timestamp', descending: false)
.snapshots();}
}