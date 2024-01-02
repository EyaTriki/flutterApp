import 'dart:typed_data';
import 'package:app/components/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

 Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    try {
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference ref = _storage.ref().child(childName);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      // Gérer les erreurs de téléchargement de l'image ici
      print("Error uploading image: $error");
      throw error;
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  late String userId;
  String imageUrl = ''; // L'URL de l'image sera vide par défaut

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    userId = user!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          usernameController.text = documentSnapshot['username'];
          bioController.text = documentSnapshot['bio'];
          imageUrl = documentSnapshot['imageLink'] ?? ''; // Image URL ou vide
        });
      }
    });
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        // Mettre à jour l'image affichée et sauvegarder l'image dans Firestore
        _updateImage(img);
      });
    }
  }

  void _updateImage(Uint8List file) async {
    try {
      String imageUrl = await uploadImageToStorage('ProfileImage', file);
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'imageLink': imageUrl,
      }).then((_) {
        // Mise à jour de l'image réussie
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Picture Updated')),
        );
      }).catchError((error) {
        // Gérer les erreurs lors de la mise à jour de l'image
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture')),
        );
      });
    } catch (error) {
      // Gérer les erreurs lors du téléchargement de l'image
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: selectImage,
              child: 
              CircleAvatar(
  radius: 50.0,
  backgroundImage: imageUrl.isNotEmpty
      ? NetworkImage(imageUrl) as ImageProvider<Object>
       
      : NetworkImage('https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png') as ImageProvider<Object>, // Image ou avatar par défaut
  child: imageUrl.isEmpty
      ? Container( // Conteneur transparent si aucune image n'est définie
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: selectImage,
          ),
        )
      : null, // Null pour ne pas afficher d'enfant si une image est définie
),

            ),
            SizedBox(height: 20.0),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Mettre à jour les données de l'utilisateur
                // Appeler une méthode pour mettre à jour les données de l'utilisateur (hors image)
              },
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
