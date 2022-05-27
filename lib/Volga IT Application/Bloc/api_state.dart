import '../utils/quotes.dart';

abstract class ApiState {}

class InitialState extends ApiState {}
class FailureState extends ApiState {}

class SuccessQuotesList extends ApiState {
  List<Quote> quotes;
  SuccessQuotesList(this.quotes);
}