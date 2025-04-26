import 'package:doanngon/View/page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doanngon/bloc/login_bloc.dart';
import 'homepage.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body: BlocProvider(
  create: (context) => LoginBloc(),
  child: SingleChildScrollView( // Thêm ScrollView để tránh lỗi
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
      children: [
        SizedBox(height: 200),
        Text(
          "Sign in now",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "Please sign in to continue our app",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 35),
        SizedBox(
          width: 350,
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: "email",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 350,
          child: TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "password",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: Icon(Icons.visibility_off),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: Text("Forget Password?")),
        ),
        SizedBox(height: 10),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FullAppPage()));
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
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
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              context.read<LoginBloc>().add(
                                    LoginSubmitted(
                                      _usernameController.text,
                                      _passwordController.text,
                                    ),
                                  );
                            },
                      child: state is LoginLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?", style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signuppage()));
                        },
                        child: Text("Sign up"),
                      )
                    ],
                  ),
                  Text("Or connect"),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.facebook, color: Colors.blue, size: 40)),
                      IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 35)),
                      IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.twitter, color: Colors.blue, size: 35)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  ),
),
);
}
}
