import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class PageChanged extends HomeEvent {
  final int pageIndex;

  const PageChanged(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}

// States
abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  final int pageIndex;

  const HomeInitial(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial(0)) {
    on<PageChanged>((event, emit) {
      emit(HomeInitial(event.pageIndex));
    });
  }
}
