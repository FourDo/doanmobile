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
  final AuthLogin _authLogin = AuthLogin();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
  emit(LoginLoading());
  try {
    print("Đang đăng nhập với username: ${event.username}, password: ${event.password}");
    
    final user = User(username: event.username, password: event.password);
    final success = await _authLogin.login(user);
    
    print("Kết quả từ AuthLogin: $success");
    
    if (success) {
      print("Đăng nhập thành công");
      emit(LoginSuccess());
    } else {
      print("Đăng nhập thất bại từ server");
      emit(LoginFailure('Tên đăng nhập hoặc mật khẩu không đúng'));
    }
  } catch (e) {
    print("Lỗi chi tiết: ${e.toString()}");
    emit(LoginFailure('Đã có lỗi xảy ra: ${e.toString()}'));
  }
}

}