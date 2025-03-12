import 'package:bloc/bloc.dart';
import 'package:doanngon/Model/user.dart';
import 'package:doanngon/Repository/auth_signup.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class SignupSubmitted extends SignupEvent {
  final String username;
  final String email;
  final String password;

  const SignupSubmitted(this.username, this.email, this.password);

  @override
  List<Object> get props => [username, email, password];
}

// States
abstract class SignupState extends Equatable {
  const SignupState();
}

class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupLoading extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupSuccess extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupFailure extends SignupState {
  final String error;

  const SignupFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthSignup _authSignup = AuthSignup();

  SignupBloc() : super(SignupInitial()) {
    on<SignupSubmitted>(_onLoginSubmitted);
  }
  Future <void> _onLoginSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      final user = User(username: event.username, password: event.password, email: event.email);
      final success = await _authSignup.register(user);
      
      
       if (success) {
        emit(SignupSuccess());
      } else {
        emit(SignupFailure('Signup failed'));
      }
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
