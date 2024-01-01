import 'package:app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  
  const MyDrawer({super.key});
void signOut(){
//get auth service
 FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child:Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
          //drawer header
         
    children:[
          DrawerHeader(child: Icon(
            Icons.message,
            size: 90,
               color: Colors.grey[800],
            //color:Theme.of(context).colorScheme.inversePrimary ,
          ),
          ),
          const SizedBox(height: 25.0,),
          //home title
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.group,
               color:Theme.of(context).colorScheme.inversePrimary ),
              title: Text("U S E R S"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.person,
               color:Theme.of(context).colorScheme.inversePrimary ),
              title: const Text("P R O F I L E"),
              onTap: (){
                //pop drawer
                Navigator.pop(context);
                //navigate to profile page
                Navigator.pushNamed(context, '/profile_page');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
          
          ),
        ],),
          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 25),
            child: ListTile(
              leading: Icon(Icons.logout,
               color:Theme.of(context).colorScheme.inversePrimary ),
              title: const Text("L O G O U T"),
              onTap: (){
                Navigator.pop(context);
                //logout
                signOut();
              },
            ),
          )
        ],
      ),
    );
}
}