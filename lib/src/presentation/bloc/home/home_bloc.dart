import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_demo/src/domain/repositories/contact_repository.dart';
import 'package:mobile_test_demo/src/presentation/bloc/home/home_event.dart';
import 'package:mobile_test_demo/src/presentation/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ContactRepository contactRepository;

  HomeBloc({required this.contactRepository}) : super(HomeInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(HomeLoading());
      try {
        final contacts = await contactRepository.fetchContacts();
        emit(HomeLoaded(contacts));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
