import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/api_provider.dart';
import '../utils/quotes.dart';
import 'api_events.dart';
import 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(InitialState()) {
    on<GetQuotesEvent>(_getQuotesList);
  }

  _getQuotesList(GetQuotesEvent event, Emitter<ApiState> emits) async {
    try {
      List<Quote> toDoList = await ApiProvider().getData();
      emit(SuccessQuotesList(toDoList));
    } catch (error) {
      print(error);
      emit(FailureState());
    }
  }
}