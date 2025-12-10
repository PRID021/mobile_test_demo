part of 'app_bloc.dart';

abstract class AppEvent {}

class AppStarted extends AppEvent {}

class LoggedIn extends AppEvent {
  LoggedIn();
}

class LoggedOut extends AppEvent {}
