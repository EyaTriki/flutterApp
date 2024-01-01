import 'dart:typed_data';

import 'package:app/components/utils.dart';
import 'package:app/resources/add_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
Uint8List? _image;
final TextEditingController nameController = TextEditingController();
final TextEditingController bioController =TextEditingController();

void selectImage() async{
  Uint8List img = await pickImage(ImageSource.gallery);
setState(() {
  _image = img;
});
}
void saveProfile() async{
  String name = nameController.text;
  String bio = bioController.text;

String resp = await StoreData().saveData(name: name, bio: bio, file: _image!);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),
    backgroundColor: 
        Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24,),
                Stack(
                  children: [
                     _image != null ?
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image !),
                    ):
                    const CircleAvatar(
                       radius: 64,
                       backgroundImage:NetworkImage('https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),
                       ),
                       Positioned(child: IconButton(onPressed: selectImage, 
                       icon: const Icon(Icons.add_a_photo),
                       ),
                       bottom: -10,
                       left: 80,
                       )
                  ],
                ),
                  const SizedBox(height: 24,),
                TextField(
                controller: nameController,
                decoration: InputDecoration(
                hintText: 'Enter Name',
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
                ),),
                  const SizedBox(height: 24,), 
                    TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                hintText: 'Enter Bio',
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
                ),),
                  const SizedBox(height: 24,), 
                  ElevatedButton(onPressed: saveProfile,child: Text('Save Profile'),)
              ],
            ),
          ),
        )
    );
  }
}