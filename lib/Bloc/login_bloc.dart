import 'package:bloc/bloc.dart';
import 'package:doanngon/Model/user.dart';
import 'package:doanngon/Repository/auth_login.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  const LoginSubmitted(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

// States
abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthLogin _authLogin = AuthLogin(); // Add this line

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = User(username: event.username, password: event.password); // Update to use the new User model
      final success = await _authLogin.login(user); // Use AuthLogin repository

      if (success) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Login failed'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}