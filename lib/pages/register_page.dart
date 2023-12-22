import 'package:app/components/my_button.dart';
import 'package:app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
 final void Function()? onTap;
  const RegisterPage({super.key , 
  required this.onTap });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

//sign up user
void signUp(){

}  

  @override
  Widget build(BuildContext context) {
     final emailController =TextEditingController();
     final passwordController= TextEditingController();
     final confirmPasswordController= TextEditingController();
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
            const SizedBox(height:10),
                //create account msg
            Text("Let's create an account for you!",
            style: TextStyle(fontSize: 16,),),
            const SizedBox(height:15),
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
             const SizedBox(height:10),
              //password textfield
             MyTextField(
              controller:confirmPasswordController ,
             hintText: 'Confirm password',
             obscureText: true),
             const SizedBox(height:10),
                //sign up btn
            MyButton(onTap:signUp, text: "Sign Up"),
            const SizedBox(height:25),
                // not a member? register now
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already a member?'),
                 const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login now',
                    style: TextStyle(fontWeight: FontWeight.bold,
                    ),
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