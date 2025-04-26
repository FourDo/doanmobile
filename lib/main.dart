import 'package:doanngon/Bloc/bookingnow_bloc.dart';
import 'package:doanngon/Bloc/login_bloc.dart';
import 'package:doanngon/View/page/homepage.dart';
import 'package:doanngon/View/page/loginpage.dart';
import 'package:doanngon/View/page/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/signup_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/favorite_bloc.dart';
import 'package:doanngon/View/page/FavoriteScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignupBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => BookingBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Welcomepage(),
        routes: {
          '/favorites': (context) => const FavoriteScreen(),
        },
      ),
    );
  }
}
