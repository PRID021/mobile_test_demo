import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_demo/src/core/storage/token_storage.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final TokenStorage tokenStorage;

  AppBloc({required this.tokenStorage}) : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    final token = await tokenStorage.getAccessToken();
    print(
        "[AppBlock ${this.hashCode}] _onAppStarted Access token: $token - hascode: ${this.hashCode}");
    if (token != null && token.isNotEmpty) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AppState> emit) async {
    emit(Authenticated());
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AppState> emit) async {
    print(
        "[AppBlock ${this.hashCode}] Logging out, clearing tokens - currentState: $state");
    tokenStorage.clear();
    emit(Unauthenticated());
  }
}
