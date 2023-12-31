import 'package:app/components/my_button.dart';
import 'package:app/components/my_text_field.dart';
import 'package:app/main.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
 final void Function () ? onTap;
  const LoginPage({super.key ,
  required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController =TextEditingController();
  final passwordController =TextEditingController();
// signin methode
void signIn() async{
// get the auth service
final authService = Provider.of<AuthService>(context,listen:false);
try{
await authService.signInWithEmailandPassword(
  emailController.text,
  passwordController.text,);
}catch(e){
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(
    e.toString(),
  ),
  )
);
}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Center(
          child: Padding(
            padding:const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(Icons.message ,
                 size: 90,
                 color: Colors.grey[800],),
            const SizedBox(height:25),
                //wlc back msg
            Text("Welcome back you've been missed!",
            style: TextStyle(fontSize: 16,),),
            const SizedBox(height:25),
            //email textfield
            MyTextField(
              controller:emailController ,
             hintText: 'Email',
             obscureText: false),
             const SizedBox(height:10),
                //password textfield
             MyTextField(
              controller:passwordController ,
             hintText: 'Password',
             obscureText: true),
             const SizedBox(height:25),
                //sign in btn
            MyButton(onTap:signIn , text: "Sign In"),
            const SizedBox(height:50),
                // not a member? register now
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member?'),
                 const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Register now',
                    style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
                )
              ],
            )
              ],
            ),
          ),
        ),
      ) ,
    );
  }
}