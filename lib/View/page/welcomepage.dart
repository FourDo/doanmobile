import 'dart:async';
import 'package:flutter/material.dart';
import 'introlpage.dart';

  class Welcomepage extends StatefulWidget {
    const Welcomepage({super.key});
  
    @override
    State<Welcomepage> createState() => _WelcomepageState();
  }
  
  class _WelcomepageState extends State<Welcomepage> {
    void initState(){
      super.initState();
      Timer(Duration(seconds: 3),(){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Introlpage()));
      });
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Text("Travenor",style: TextStyle(color: Colors.white,fontSize: 42,fontWeight: FontWeight.bold),), // Logo của app
        ),
      );;
    }
  }
