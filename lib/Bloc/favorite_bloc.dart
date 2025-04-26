import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


abstract class FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final Map<String, dynamic> destination;
  AddFavorite(this.destination);
}

class RemoveFavorite extends FavoriteEvent {
  final Map<String, dynamic> destination;
  RemoveFavorite(this.destination);
}

class LoadFavorites extends FavoriteEvent {}


abstract class FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Map<String, dynamic>> favorites;
  FavoriteLoaded({required this.favorites});
}

// Bloc implementation
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);

    add(LoadFavorites());
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString('favorites') ?? '[]';
      final favorites = List<Map<String, dynamic>>.from(
          json.decode(favoritesString) as List);
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e, stackTrace) {
      // Log the error and stack trace
      print('Error in LoadFavorites: $e');
      print(stackTrace);
      emit(FavoriteLoaded(favorites: [])); // Fallback to an empty list
    }
  }

  Future<void> _onAddFavorite(
      AddFavorite event, Emitter<FavoriteState> emit) async {
    try {
      if (state is FavoriteLoaded) {
        final currentFavorites = (state as FavoriteLoaded).favorites;
        final updatedFavorites = [...currentFavorites, event.destination];
        await _saveFavorites(updatedFavorites);
        emit(FavoriteLoaded(favorites: updatedFavorites));
      }
    } catch (e, stackTrace) {
      // Log the error and stack trace
      print('Error in AddFavorite: $e');
      print(stackTrace);
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoriteState> emit) async {
    try {
      if (state is FavoriteLoaded) {
        final currentFavorites = (state as FavoriteLoaded).favorites;
        final updatedFavorites = currentFavorites
            .where((destination) => destination != event.destination)
            .toList();
        await _saveFavorites(updatedFavorites);
        emit(FavoriteLoaded(favorites: updatedFavorites));
      }
    } catch (e, stackTrace) {
      // Log the error and stack trace
      print('Error in RemoveFavorite: $e');
      print(stackTrace);
    }
  }

  Future<void> _saveFavorites(List<Map<String, dynamic>> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = json.encode(favorites);
      await prefs.setString('favorites', favoritesString);
    } catch (e, stackTrace) {
      // Log the error and stack trace
      print('Error in _saveFavorites: $e');
      print(stackTrace);
    }
  }
}
