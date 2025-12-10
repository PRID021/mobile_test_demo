part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class Authenticated extends AppState {}

class Unauthenticated extends AppState {}
