import 'package:doanngon/View/page/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doanngon/bloc/signup_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class signuppage extends StatefulWidget {
  const signuppage({super.key});

  @override
  State<signuppage> createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => SignupBloc(),
        child: Column(
          children: [
            SizedBox(height: 200,),
            Text("Sign up now",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("Please fill the details and create account",style: TextStyle(color: Colors.grey),),
            SizedBox(height: 35,),
            SizedBox(width: 350,child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  hintText:"username",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),),
            SizedBox(height: 20,),
            SizedBox(width: 350,child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText:"email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),),
            SizedBox(height: 20,),
            SizedBox(width: 350,child: TextField(obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                  hintText:"password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: Icon(Icons.visibility_off)
              ),),),
            SizedBox(height: 30,),
            BlocListener<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state is SignupSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signup successful!')),
                  );
                  // Navigate to the next page if needed
                } else if (state is SignupFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: BlocBuilder<SignupBloc, SignupState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: state is SignupLoading
                              ? null
                              : () {
                                  context.read<SignupBloc>().add(
                                        SignupSubmitted(
                                          _usernameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                        ),
                                      );
                                },
                          child: state is SignupLoading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account",style: TextStyle(color: Colors.grey),),
                          TextButton(onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginpage()));
                          }, child: Text("Sign up"))
                        ],
                      ),
                      Text("Or connect"),
                      SizedBox(height: 80,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.facebook,color: Colors.blue,size: 40,),),
                          IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.google,color: Colors.red,size: 35)),
                          IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.twitter,color: Colors.blue,size: 35)),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
